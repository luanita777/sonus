project('sonus', 'vala', 'c')

# Dependencies (the ones you would use with valac)
dependencies = [
    dependency('glib-2.0'),
    dependency('gobject-2.0'),
    dependency('gio-2.0'),
    dependency('sqlite3'),
    dependency('gee-0.8')
]

# Source files
domain_sources = files(
    'src/domain/album.vala',
    'src/domain/errors.vala',
    'src/domain/group.vala',
    'src/domain/groupMembership.vala',
    'src/domain/performerType.vala',
    'src/domain/performer.vala',
    'src/domain/person.vala',
    'src/domain/song.vala'
)

db_sources = files(
    'src/db/dataBaseManager.vala',
    'src/db/dao/mainDAO.vala',
    'src/db/dao/songDAO.vala',
    'src/db/dao/performerDAO.vala',
    'src/db/dao/albumDAO.vala',
    'src/db/dao/personDAO.vala',
    'src/db/dao/groupDAO.vala',
    'src/db/dao/membershipDAO.vala',
)

# Test files
domain_test_sources = files(
    'tests/testDomain/testAlbum.vala',
    'tests/testDomain/testGroup.vala',
    'tests/testDomain/testGroupMembership.vala',
    'tests/testDomain/testSong.vala',
    'tests/testDomain/testPerformerType.vala',
    'tests/testDomain/testPerformer.vala',
    'tests/testDomain/testPerson.vala',
    'tests/testDomain/testDomain.vala'
)

db_test_sources = files (
    'tests/testDB/testDataBaseManager.vala',
    'tests/testDB/testDB.vala',
    'tests/testDB/DAO/baseTestDAO.vala',
    'tests/testDB/DAO/testSongDAO.vala',
    'tests/testDB/DAO/testPerformerDAO.vala',
    'tests/testDB/DAO/testAlbumDAO.vala',
    'tests/testDB/DAO/testPersonDAO.vala',
    'tests/testDB/DAO/testGroupDAO.vala',
    'tests/testDB/DAO/testMembershipDAO.vala',
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