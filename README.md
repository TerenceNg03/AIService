# AI Service

A macOS menu bar app that integrates with the DeepSeek API.

## Features
- **Prompt**: General question and text refine.
- **Lightweight**: Built entirely in SwiftUI, only 1.2 MB.
- **Secure API Key Storage**: Utilizes Keychain Service for secure API key management.
- **Easy Integration**: Supports app URL schemes:
  - `aiservice://ask?q={query}`: Submit a question to AI.
  - `aiservice://refine?q={query}`: Refine a text snippet.
  - More features to be added.
- **Convenience**:
  - A floating window summoned by `option+space`.
  - Read outputs in real time.
  - Icon changes according to the state.

## ScreenShot
<img width="486" alt="截屏2024-10-11 09 54 56" src="https://github.com/user-attachments/assets/882d332f-315e-4bee-89ba-42d5bdad3acd">
