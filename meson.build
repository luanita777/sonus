project('sonus', 'vala', 'c')

# Dependencies (the ones you would use with valac)
dependencies = [
    dependency('glib-2.0'),
    dependency('gobject-2.0'),
    dependency('sqlite3'),
]

# Source files
sources = files(
    'src/domain/performerType.vala',
    'src/domain/song.vala'
)

# Test files
test_sources = files(
    'tests/testDomain/testSong.vala',
    'tests/testDomain/testPerformerType.vala',
    'tests/testDomain/testMain.vala'
)

# Make the executable
test_exe = executable('testProgram',
    sources + test_sources,
    dependencies: dependencies
)

# Register the test
test('unit_tests', test_exe)