# Scripts

Custom wrapper over mandatory scripts

## TRIVIA

all scripts have about the same interface

u may pass tabs(put literal tabs inside "", NOT escape symbol) or spaces(e.g. "    ") in any script that may produce output

u may pass verbose option(**-v**) in certain scripts, they will propagate it to all subcalls that may utilize it

### My strategy:
- Use **./test_junk.sh** or **TEST_ALL.sh**
- if fails, check with **-v** flag: **./test_junk.sh -v** or **./TEST_ALL.sh -v**

## YOU MUST

- **NEVER** FUCKING USE WINDOWS LINE ENDINGS IN ANY FUCKING pos/neg_nn_ **out**.txt FILES (!!!)

## Hierarchy

- **TEST_ALL.sh** (recommended to have)
  - **test_junk.sh**
    - **CodeChecker.exe** (optional)
    - **check_scripts.sh**
    - **check_builds.sh**
    - **check_functional_tests.sh**
    - ...

## Feedback

tg: [@JIUMOHHbIU](https://t.me/JIUMOHHbIU)
