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
                typeCheckingMode = 'off',
                libraryTypes = true,
                parameterHints = true,
                memberHints = true,
                autoImportCompletions = true,
                autoSearchPaths = true,
                inlayHints = {
                    genericTypes = true
                }
            }
        }
    }
}
