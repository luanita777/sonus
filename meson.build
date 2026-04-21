project('sonus', 'vala', 'c')

# Dependencies (the ones you would use with valac)
dependencies = [
    dependency('glib-2.0'),
    dependency('gobject-2.0'),
    dependency('sqlite3'),
]

# Source files
sources = files(
    'src/domain/album.vala',
    'src/domain/errors.vala',
    'src/domain/group.vala',
    'src/domain/groupMembership.vala',
    'src/domain/performerType.vala',
    'src/domain/performer.vala',
    'src/domain/person.vala',
    'src/domain/song.vala'
)

# Test files
test_sources = files(
    'tests/testDomain/testAlbum.vala',
    'tests/testDomain/testGroup.vala',
    'tests/testDomain/testGroupMembership.vala',
    'tests/testDomain/testSong.vala',
    'tests/testDomain/testPerformerType.vala',
    'tests/testDomain/testPerformer.vala',
    'tests/testDomain/testPerson.vala',
    'tests/testDomain/testMain.vala'
)

# Make the executable
test_exe = executable('testProgram',
    sources + test_sources,
    dependencies: dependencies
)

# Register the test
test('unit_tests', test_exe)