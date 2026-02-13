#!/usr/bin/env python
# -*- coding: utf-8 -*-
from faster_whisper import WhisperModel
import sys
import os
from pathlib import Path

def transcrever_audio(caminho_audio, pasta_saida="transcricoes"):
    print(f"📝 Transcrevendo: {caminho_audio}...")
    
    # Carrega o modelo (sem espaços!)
    model = WhisperModel("small", device="cpu", compute_type="int8")
    
    try:
        segments, info = model.transcribe(
            caminho_audio,
            language="pt",
            beam_size=5,
            vad_filter=True,
            condition_on_previous_text=False
        )
    except Exception as e:
        print(f"❌ Erro ao transcrever: {e}")
        sys.exit(1)
    
    transcricao = ""
    for segment in segments:
        transcricao += f"[{segment.start:.1f}s -> {segment.end:.1f}s] {segment.text}\n"
    
    nome_arq = Path(caminho_audio).stem + ".txt"
    caminho_saida = os.path.join(pasta_saida, nome_arq)
    
    try:
        with open(caminho_saida, "w", encoding="utf-8") as f:
            f.write(transcricao)
        print(f"✅ Transcrição salva em: {caminho_saida}")
    except Exception as e:
        print(f"❌ Erro ao salvar: {e}")
        sys.exit(1)

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Uso: python transcrever.py <caminho_do_audio>")
        print("Exemplo: python transcrever.py audios/entrevista.mp3")
        sys.exit(1)
    
    audio = sys.argv[1]
    if not os.path.exists(audio):
        print(f"❌ Arquivo não encontrado: {audio}")
        sys.exit(1)
    
    os.makedirs("transcricoes", exist_ok=True)
    transcrever_audio(audio)