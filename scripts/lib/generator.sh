#!/usr/bin/env bash
# generator.sh — Gera hosts/main/hamra.json
#
# Escreve os dados coletados em CONFIG para hamra.json,
# que é consumido pelo hamra.nix em tempo de avaliação.
#
# Não gera código Nix — apenas dados JSON.
# O Nix é responsável por traduzir os dados em configuração.

generator_main() {
  print_section "Gerando configuração"

  mkdir -p "$(dirname "$HAMRA_JSON")"

  cat > "$HAMRA_JSON" <<EOF
{
  "userName": "${CONFIG[userName]}",
  "hostname": "${CONFIG[hostname]}",
  "timezone": "${CONFIG[timezone]}",
  "locale": "${CONFIG[locale]}",
  "keymap": "${CONFIG[keymap]}",
  "gpu": "${CONFIG[gpu]}",
  "loader": "${CONFIG[loader]}",
  "grubDevice": "${CONFIG[grubDevice]}",
  "session": "${CONFIG[session]}"
}
EOF

  echo "  ✓ Gerado: $HAMRA_JSON"

  # ── Senha (injeção direta no sistema, sem arquivo) ───────────
  if [ -n "${CONFIG[password]}" ] && [ "${CONFIG[password]}" != "__EXISTS__" ]; then
    echo "  Definindo senha para ${CONFIG[userName]}..."
    echo "${CONFIG[userName]}:${CONFIG[password]}" | chpasswd
    echo "  ✓ Senha definida"
  fi

  # Se o PROJECT_DIR difere da origem, copia hamra.json
  # também para o diretório fonte, assim o rebuild funciona
  # de qualquer lugar (projeto ou /etc/nixos).
  local script_dir
  script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
  local source_dir
  source_dir="$(dirname "$script_dir")"
  if [ "$source_dir" != "$PROJECT_DIR" ]; then
    cp "$HAMRA_JSON" "$source_dir/hosts/main/hamra.json"
    echo "  ✓ Copiado também para $source_dir/hosts/main/hamra.json"
  fi
}
