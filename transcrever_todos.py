#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Transcrição em lote - Biblioteca do Senado Federal
"""
from faster_whisper import WhisperModel
import os
from pathlib import Path
import time
import sys

PASTA_AUDIOS = "audios"
PASTA_SAIDA = "transcricoes"
MODELO = "small"

def formatar_tempo(segundos):
    m, s = divmod(int(segundos), 60)
    h, m = divmod(m, 60)
    return f"{h:02d}:{m:02d}:{s:02d}" if h else f"{m:02d}:{s:02d}"

def transcrever_todos():
    os.makedirs(PASTA_SAIDA, exist_ok=True)
    extensoes = ('.mp3', '.wav', '.m4a', '.flac', '.ogg', '.wma')
    arquivos = [f for f in os.listdir(PASTA_AUDIOS)
                if os.path.isfile(os.path.join(PASTA_AUDIOS, f))
                and f.lower().endswith(extensoes)]
    
    if not arquivos:
        print(f"⚠️  Nenhum arquivo de áudio encontrado em '{PASTA_AUDIOS}'")
        return
    
    print(f"🔍 Encontrados {len(arquivos)} áudio(s):")
    for arq in arquivos:
        print(f"   • {arq}")
    
    print(f"\n⏳ Carregando modelo '{MODELO}'...")
    model = WhisperModel(MODELO, device="cpu", compute_type="int8")
    
    print("\n" + "="*70)
    print("  INICIANDO TRANSCRIÇÕES")
    print("="*70)
    
    total_inicial = time.time()
    total_sucesso = 0
    
    for i, arquivo in enumerate(arquivos, 1):
        caminho_audio = os.path.join(PASTA_AUDIOS, arquivo)
        nome_base = Path(arquivo).stem
        caminho_saida = os.path.join(PASTA_SAIDA, f"{nome_base}.txt")
        
        print(f"\n[{i}/{len(arquivos)}] 📝 {arquivo}")
        try:
            segments, info = model.transcribe(
                caminho_audio,
                language="pt",
                beam_size=5,
                vad_filter=True,
                condition_on_previous_text=False
            )
            
            transcricao = f"""AUTOR: Biblioteca do Senado Federal
DATA TRANSCRIÇÃO: {time.strftime('%Y-%m-%d %H:%M:%S')}
ARQUIVO ORIGINAL: {arquivo}
IDIOMA: Português
{'='*70}
TRANSCRIÇÃO
{'='*70}
"""
            for segment in segments:
                transcricao += f"{segment.text}\n"
            
            with open(caminho_saida, "w", encoding="utf-8") as f:
                f.write(transcricao)
            print(f"    ✅ Salvo: {nome_base}.txt")
            total_sucesso += 1
        except Exception as e:
            print(f"    ❌ Erro: {str(e)[:100]}")
    
    total_final = time.time() - total_inicial
    print("\n" + "="*70)
    print(f" ✅ CONCLUÍDO: {total_sucesso} de {len(arquivos)} áudios transcritos")
    print(f" ⏱️  Tempo total: {formatar_tempo(total_final)}")
    print(f" 📁 Resultados em: {os.path.abspath(PASTA_SAIDA)}")
    print("="*70)

if __name__ == "__main__":
    transcrever_todos()