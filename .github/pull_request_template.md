## Descrizione

<!-- Spiega brevemente cosa cambia e perché -->

## Checklist

- [ ] Ogni nuovo file in `Core/`, `Services/`, `Extensions/`, `Utilities/` ha il corrispondente `*Tests.swift` in `MeetingBarTests/`
- [ ] Nuove funzioni hanno test per happy path + almeno un error path
- [ ] `xcodebuild test` passa in locale prima di aprire la PR
- [ ] Nessuna coverage regression > 2% rispetto al branch principale
