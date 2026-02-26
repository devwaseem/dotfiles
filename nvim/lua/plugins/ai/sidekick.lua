return {
    "folke/sidekick.nvim",
    opts = {
        cli = {
            win = {
                layout = "left",
                split = {
                    width = 0, -- set to 0 for default split width
                },
            },
            mux = {
                backend = "tmux",
                enabled = true,
                create = "terminal"
            },
            prompts = {

                -- Context Injections
                buffers         = "{buffers}",
                file            = "{file}",
                line            = "{line}",
                position        = "{position}",
                quickfix        = "{quickfix}",
                selection       = "{selection}",
                ["function"]    = "{function}",
                class           = "{class}",

                changes         = "Can you review my changes?",
                diagnostics     = "Can you help me fix the diagnostics in {file}?\n{diagnostics}",
                diagnostics_all = "Can you help me fix these diagnostics?\n{diagnostics_all}",

                explain         = "Explain how {this} works in plain English.",
                fix             = "Fix the issues in {this} while maintaining the current logic.",
                optimize        = "How can the performance of {this} be improved without sacrificing readability?",
                review          = "Perform a comprehensive code review of {file}. Focus on logic and style.",
                tests           = "Write a comprehensive suite of unit tests for {this}, covering happy paths and failures.",
                document        = "Add clear, idiomatic documentation to {function|line}.",

                -- ===  CODE QUALITY & REFACTORING ===
                refactor        = "Refactor {this} to improve readability and reduce cognitive complexity.",
                naming          = "Suggest more descriptive and intention-revealing names for identifiers in {selection}.",
                simplify        = "Identify redundant logic or over-engineering in {this} and suggest a simpler way.",
                modernize       = "Rewrite {this} using modern idiomatic patterns for this language.",
                dry             = "Check {file} for duplicated logic and suggest how to abstract it.",
                types           = "Add type annotations or documentation comments to {this} for better clarity.",
                style           = "Rewrite {selection} to match the coding patterns and conventions used in {buffers}.",

                -- ===  DEEP LOGIC & PERFORMANCE ===
                complexity      = "Analyze the time and space complexity ($O$ notation) of {this}.",
                bottleneck      = "Identify the most likely performance bottleneck in {this} as input size scales.",
                trace           = "Trace the data flow through {this} step-by-step to explain how inputs become outputs.",
                state           = "Trace all state mutations in {this}. Check for race conditions or inconsistency risks.",
                logic_check     = "Check {this} for logical fallacies, off-by-one errors, or potential deadlocks.",
                assumptions     = "List every implicit assumption {this} makes about its environment or input data.",

                -- ===  SECURITY & ROBUSTNESS ===
                security        = "Check {this} for security vulnerabilities like injection or unsafe data handling.",
                adversary       = "Act as a malicious actor. Find 3 ways to exploit or break the logic in {selection}.",
                edge_cases      = "What inputs (nulls, empty collections, extreme values) could break {function}?",
                audit           = "Perform a deep security audit of {file}, focusing on validation boundaries.",
                errors          = "Make the error handling in {this} more robust and provide better feedback.",

                -- ===  ARCHITECTURE & STRATEGY ===
                impact          = "What are the potential side effects of modifying {this}? What else in {file} might break?",
                contract        = "Review the public interface of {this}. Is it intuitive and properly decoupled?",
                decouple        = "How can I reduce the dependencies of {this} to make it more modular?",
                testable        = "How could {this} be restructured to be more easily unit-tested?",
                patterns        = "Which design patterns are used in {class}, and are they the best choice here?",
                debt            = "Identify technical debt in {selection} and rank it by long-term impact.",
                stepwise        = "Outline a step-by-step refactoring plan for {this}. Don't write code, just the plan.",
                rationalize     = "What is the likely purpose of this logic? Identify the trade-offs made here.",

                -- ===  WORKFLOW & KNOWLEDGE ===
                commit          =
                "Analyze the staged changes and generate a Conventional Commit message. Use the format: <type>(<scope>): <subject>. Keep it concise.",
                readme          = "Draft a technical README section for the code in {file}.",
                summarize       = "Provide a high-level summary of {this} for a non-technical stakeholder.",
                onboarding      = "Write a brief 'Quick Start' summary of {file} for a new developer.",
                glossary        = "Identify domain-specific terms in {this} and provide brief definitions.",
                critique        = "Act as a harsh senior lead. Provide a brutal critique of the logic in {selection}.",
                duck            = "I'll explain a problem in {this}. Ask me 3 probing questions to help me solve it.",
                mock            = "Generate realistic mock data for testing {this}.",
                regex           = "Explain exactly what this regular expression in {this} matches.",
            },
            picker = "telescope",
            ui = {
                icons = {
                    attached          = " ",
                    started           = " ",
                    installed         = " ",
                    missing           = " ",
                    external_attached = "󰖩 ",
                    external_started  = "󰖪 ",
                    terminal_attached = " ",
                    terminal_started  = " ",
                },
            }
        }
    },
    keys = {
        {
            "<tab>",
            function()
                -- if there is a next edit, jump to it, otherwise apply it if any
                if not require("sidekick").nes_jump_or_apply() then
                    return "<Tab>" -- fallback to normal tab
                end
            end,
            expr = true,
            desc = "Goto/Apply Next Edit Suggestion",
        },
        {
            "<leader>0a",
            function() require("sidekick.cli").toggle() end,
            desc = "Sidekick Toggle CLI",
        },
        {
            "<leader>0s",
            function() require("sidekick.cli").select() end,
            -- Or to select only installed tools:
            -- require("sidekick.cli").select({ filter = { installed = true } })
            desc = "Select CLI",
        },
        {
            "<leader>0d",
            function() require("sidekick.cli").close() end,
            desc = "Detach a CLI Session",
        },
        {
            "<leader>0t",
            function() require("sidekick.cli").send({ msg = "{this}" }) end,
            mode = { "x", "n" },
            desc = "Send This",
        },
        {
            "<leader>0f",
            function() require("sidekick.cli").send({ msg = "{file}" }) end,
            desc = "Send File",
        },
        {
            "<leader>0v",
            function() require("sidekick.cli").send({ msg = "{selection}" }) end,
            mode = { "x" },
            desc = "Send Visual Selection",
        },
        {
            "<leader>0p",
            function() require("sidekick.cli").prompt() end,
            mode = { "n", "x" },
            desc = "Sidekick Select Prompt",
        },
        {
            "<leader>00",
            function() require("sidekick.cli").toggle({ name = "opencode", focus = true }) end,
            desc = "Sidekick Toggle opencode",
        },
    },
}
