return {
    cmd = { 'basedpyright-langserver', '--stdio' },
    filetypes = { "python" },
    root_markers = {
        'pyproject.toml',
        'setup.py',
        'setup.cfg',
        'requirements.txt',
        'Pipfile',
        'pyrightconfig.json',
        '.git',
    },
    settings = {
        disableOrganizeImports = true,
        basedpyright = {
            analysis = {
                diagnosticMode = 'workspace',
                typeCheckingMode = 'recommended',
                useLibraryCodeForTypes = true,
                autoImportCompletions = true,
                autoSearchPaths = true,
                autoFormatStrings = true,
                inlayHints = {
                    variableTypes = true,
                    callArgumentNames = true,
                    callArgumentNamesMatching = true,
                    functionReturnTypes = true,
                    genericTypes = true,
                },
                -- Ignore all files for analysis to exclusively use Ruff for linting
                ignore = { '*' },
            }
        }
    }
}
