namespace :test do
  namespace :functionals do
    # ref: http://rpheath.com/posts/394-get-the-most-out-of-test-unit
    Rake::TestTask.new(:modules) do |t|
      t.libs << 'test'
      t.verbose = true
      t.test_files = FileList['test/functional/admin/*_test.rb','test/functional/publish/*_test.rb','test/functional/retail/*_test.rb']
    end
    Rake::Task['test:functionals:modules'].comment = "run all modules' functional tests"
  end
end
