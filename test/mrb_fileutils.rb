##
## FileUtils Test
##

assert("FileUtils") do
  assert_equal Module, FileUtils.class
  assert_equal Module, FileUtils::Verbose.class
  assert_equal Module, FileUtils::NoWrite.class
  assert_equal Module, FileUtils::DryRun.class
end

assert("FileUtils#pwd") do
  assert_equal Dir.pwd, FileUtils.pwd
  assert_equal FileUtils.pwd, FileUtils.getwd
end

assert("FileUtils#cd") do
  FileUtils.cd '/tmp', {verbose: true}
  assert_equal File.realpath('/tmp'), FileUtils.pwd
end

assert("FileUtils#uptodate?") do
  old = Tempfile.new 'old'
  oldpath = old.path
  sleep 1
  new = Tempfile.new 'new'
  newpath = new.path

  assert_true FileUtils.uptodate?(newpath, [oldpath])
  assert_false FileUtils.uptodate?(newpath, [oldpath, newpath])
end

assert("FileUtils#mkdir") do
  FileUtils.cd(Dir.tmpdir, {verbose: true})
  suffix = SecureRandom.hex
  test, tmp, data = %w(test tmp data).map {|d| "#{d}_#{suffix}"}

  FileUtils.mkdir test, {verbose: true}
  assert_true Dir.exists? test

  FileUtils.mkdir [tmp, data], {verbose: true}
  assert_true Dir.exists? tmp
  assert_true Dir.exists? data

  [test, tmp, data].each {|d| Dir.delete d}

  FileUtils.mkdir test, {verbose: true, mode: 0700}
  assert_equal "40700", sprintf("%o", File.stat(test).mode)
  Dir.delete test
end
