require 'open3'

BIN_PATH = File.join(File.dirname(__FILE__), "../mruby/bin/mrisp")

assert('lisp') do
  output, status = Open3.capture2(BIN_PATH, File.join(File.dirname(__FILE__), "../test/input/test1.lisp"))

  assert_true status.success?, "Process did not exit cleanly"
  assert_include output, "30"
end

assert('version') do
  output, status = Open3.capture2(BIN_PATH, "version")

  assert_true status.success?, "Process did not exit cleanly"
  assert_include output, "v0.1"
end
