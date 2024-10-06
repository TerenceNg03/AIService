# AI Service

A macOS menu bar app that integrates with the DeepSeek API.

## Features
- **Lightweight**: Built entirely in SwiftUI, under 1 MB.
- **Secure API Key Storage**: Utilizes Keychain Service for secure API key management.
- **Easy Integration**: Supports app URL schemes:
  - `aiservice://ask?q={query}`: Submit a question to AI.
  - `aiservice://refine?q={query}`: Refine a text snippet.
  - More features to be added.
- **Convenience**:
  - Remains in the menu bar, ensuring it doesn't disrupt your workflow.
  - Read outputs in real time. Stop anytime you want.
  - Icon changes according to the state.

## ScreenShot
<img width="344" alt="截屏2024-10-06 18 23 13" src="https://github.com/user-attachments/assets/91fb1d73-4c2f-4c31-a280-492b4ddd81b0">
