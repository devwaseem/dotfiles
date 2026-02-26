# env/bin/python
# /// script
# dependencies = [
# "google-genai",
# ]
# ///


from pathlib import Path
from google import genai
from google.genai.types import GenerateContentConfig
import sys
from google.genai import errors

# DEFAULT_MODEL = "gemini-2.0-flash"
DEFAULT_MODEL = "gemini-flash-lite-latest"
SYSTEM_PROMPT_PATH = Path(__file__).parent / "system_prompt.md"
assert SYSTEM_PROMPT_PATH.exists()
SYSTEM_PROMPT = SYSTEM_PROMPT_PATH.read_text()


def main() -> None:
    text_buffer = sys.stdin.read()

    if not text_buffer:
        sys.stderr.write("No input provided")
        sys.exit(1)

    buffer_split = text_buffer.split("---", 1)
    extra_instuctions = None
    if len(buffer_split) > 1:
        extra_instuctions = buffer_split[1]
        text_buffer = buffer_split[0]

    full_system_prompt = SYSTEM_PROMPT
    if extra_instuctions:
        full_system_prompt += "\nExtra Instructions: " + extra_instuctions

    gemini_key = Path("~/.gemini.key").read_text()
    if not gemini_key:
        sys.stderr.write("No Gemini API key found")
        sys.exit(1)

    try:
        client = genai.Client(api_key=gemini_key)
        response = client.models.generate_content(
            model=DEFAULT_MODEL,
            contents=text_buffer,
            config=GenerateContentConfig(
                temperature=0.5,
                system_instruction=full_system_prompt,
            ),
        )

        sys.stdout.write(response.text)
    except errors.APIError as e:
        print(f"Gemini API Error: {e.message}", file=sys.stderr)
        sys.exit(1)
    except Exception as e:
        print(f"An unexpected error occurred: {e}", file=sys.stderr)
        sys.exit(1)

    sys.exit(0)


if __name__ == "__main__":
    main()
