project('sonus', 'vala', 'c')

#TagLib
cc = meson.get_compiler('c')
vapi_args = ['--vapidir',
             join_paths(meson.current_source_dir(), 'vapi')]

# Dependencies (the ones you would use with valac)
dependencies = [
    dependency('glib-2.0'),
    dependency('gobject-2.0'),
    dependency('gio-2.0'),
    dependency('sqlite3'),
    dependency('gee-0.8'),
    dependency('taglib_c')
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
)

dao_sources = files (
    'src/db/dao/mainDAO.vala',
    'src/db/dao/songDAO.vala',
    'src/db/dao/performerDAO.vala',
    'src/db/dao/albumDAO.vala',
    'src/db/dao/personDAO.vala',
    'src/db/dao/groupDAO.vala',
    'src/db/dao/membershipDAO.vala',
)

miner_sources = files (
    'src/miner/errors.vala',
    'src/miner/fileReader.vala',
    'src/miner/metadataReader.vala',
    'src/miner/miner.vala'
)

main_file = files('src/main.vala')

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

db_test_sources = files(
    'tests/testDB/testDataBaseManager.vala',
    'tests/testDB/testDB.vala',    
)

dao_test_sources = files (	
    'tests/testDB/testDAO/baseTestDAO.vala',
    'tests/testDB/testDAO/testSongDAO.vala',
    'tests/testDB/testDAO/testPerformerDAO.vala',
    'tests/testDB/testDAO/testAlbumDAO.vala',
    'tests/testDB/testDAO/testPersonDAO.vala',
    'tests/testDB/testDAO/testGroupDAO.vala',
    'tests/testDB/testDAO/testMembershipDAO.vala',
)

miner_test_sources = files (
    'tests/testMiner/testMiner.vala',
    'tests/testMiner/testFileReader.vala',
    'tests/testMiner/testMetadataReader.vala'
)

test_main = files('tests/testMain.vala')


# Make the executable
all_sources = domain_sources + db_sources + dao_sources + miner_sources
all_tests = domain_test_sources + db_test_sources + dao_test_sources + miner_test_sources + test_main

# Define main executable
sonus_exe = executable('sonus',
    all_sources + main_file,
    dependencies: dependencies,
    vala_args: vapi_args,
    c_args: ['-w']
)

# Define main-test exacutable
test_exe = executable('testProgram',
    all_sources + all_tests,
    dependencies: dependencies,
    vala_args: vapi_args,
    c_args: ['-w']
)

# Register the test
test('unit_tests', test_exe)