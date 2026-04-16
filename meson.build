project('sonus', 'vala', 'c')

# Dependencies (the ones you would use with valac)
dependencies = [
    dependency('glib-2.0'),
    dependency('gobject-2.0'),
    dependency('gio-2.0'),
    dependency('sqlite3'),
]

# Source files
domain_sources = files(
    'src/domain/album.vala',
    'src/domain/errors.vala',	
    'src/domain/performerType.vala',
    'src/domain/performer.vala',
    'src/domain/song.vala'
)

db_sources = files(
    'src/db/dataBaseManager.vala'
)

# Test files
domain_test_sources = files(
    'tests/testDomain/testAlbum.vala',
    'tests/testDomain/testSong.vala',
    'tests/testDomain/testPerformerType.vala',
    'tests/testDomain/testPerformer.vala',
    'tests/testDomain/testDomain.vala'
)

db_test_sources = files (
    'tests/testDB/testDataBaseManager.vala',
    'tests/testDB/testDB.vala'
)

test_main = files('tests/testMain.vala')

# Make the executable
all_sources = db_sources + domain_sources
all_tests = domain_test_sources + db_test_sources + test_main

test_exe = executable('testProgram',
    all_sources + all_tests,
    dependencies: dependencies,
    c_args: ['-w']
)

# Register the test
test('unit_tests', test_exe)