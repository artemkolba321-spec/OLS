#!/usr/bin/env python3
from textual.app import App
from textual.widgets import Header, Static, TextArea
from textual.binding import Binding
from pathlib import Path
import sys

class UEditApp(App):
    """Minimal stable text editor (Alt-F / search removed)."""

    BINDINGS = [
        Binding("ctrl+s", "save", "Save file"),
        Binding("ctrl+q", "quit", "Quit"),
    ]

    CSS = """
    #header {
        dock: top;
        height: 3;
        content-align: center middle;
    }
    #editor {
        dock: top;
        height: 1fr;
        padding: 1;
    }
    #footer {
        dock: bottom;
        height: 1;
        content-align: center middle;
    }
    """

    def __init__(self, filepath: str):
        super().__init__()
        self.filepath: Path = Path(filepath)

        if not self.filepath.exists():
            print(f"Error: file '{self.filepath}' does not exist.")
            sys.exit(1)

        self.file_content = self.filepath.read_text(encoding="utf-8")

    async def on_mount(self) -> None:
        self.header_widget = Header(show_clock=False, id="header")
        await self.mount(self.header_widget)

        self.title_widget = Static("UEdit", id="title")
        await self.mount(self.title_widget)

        self.editor = TextArea(id="editor")
        self.editor.text = self.file_content
        await self.mount(self.editor)

        self.footer_widget = Static("^S: Save | ^Q: Quit", id="footer")
        await self.mount(self.footer_widget)

    def action_save(self) -> None:
        self.filepath.write_text(self.editor.text, encoding="utf-8")
        self.footer_widget.update(f"Saved {self.filepath.name} — ^Q to Quit")

if __name__ == "__main__":

    filename = sys.argv[1]
    app = UEditApp(filename)
    app.run()
