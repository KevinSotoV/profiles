PASS_ICON = File.expand_path('../public/images/weather-clear.png',   __FILE__) unless defined?(PASS_ICON)
FAIL_ICON = File.expand_path('../public/images/weather-showers.png', __FILE__) unless defined?(FAIL_ICON)

LINUX = RUBY_PLATFORM =~ /linux/i unless defined?(LINUX)

def escape(arg)
  arg.gsub(/\e\[..m?/, '')         # rid us of ansi escape sequences
     .gsub(/["`]/, "'")
     .gsub(/\r?\n/, "\\\\\\\\\\n")
end

def notify(pass, heading, body='')
  icon = if pass
    PASS_ICON
  else
    FAIL_ICON
  end
  cmd = if LINUX
    %(notify-send -i #{icon} --hint=int:transient:1 "#{escape heading}" "#{escape body[0..400]}")
  else
    %(growlnotify --image #{icon} -m "#{escape body}" "#{escape heading}")
  end
  system(cmd)
end

def run_tests(test, force=false)
  if force || File.exist?(test)
    puts "-" * 80
    rspec_cmd = File.exists?('.zeus.sock') ? "zeus rspec" : "rspec"
    puts "#{rspec_cmd} #{test}"
    cmd = IO.popen("#{rspec_cmd} --color --tty #{test} 2>&1")
    result = ''
    until cmd.eof?
      char = cmd.getc
      result << char
      $stdout.write(char)
    end
    if result =~/\d+ examples?, 0 failures/
      summary = $~.to_s
      secs = result.match(/Finished in ([\d\.]+ seconds)/)[1]
      notify(true, 'Test Success', summary + ' ' + secs)
    elsif result =~ /\d+ examples?, \d+ failures?/
      summary = $~.to_s
      failures = result.scan(/Failure\/Error:\s*(.*?)#/m).map(&:first)
      notify(false, summary, failures.join("\n"))
    elsif result =~ /\.rb:\d+:in `.*':\s*(.*)$/
      notify(false, 'Test Error', $1)
    else
      notify(false, 'Test Error', 'One or more tests could not run due to error.')
    end
  else
    puts "#{test} does not exist."
  end
end

def run_feature(feature, force=false)
  if force || File.exist?(feature)
    puts "-" * 80
    cuke_cmd = File.exists?('.zeus.sock') ? "zeus cucumber" : "cucumber"
    puts "#{cuke_cmd} #{feature}"
    cmd = IO.popen("#{cuke_cmd} --color #{feature} 2>&1")

    result = ''
    until cmd.eof?
      char = cmd.getc
      result << char
      $stdout.write(char)
    end
    summary = result.split("\n").last(3).join(" | ")
    if result.match(/failed/)
      summary.prepend("Scenarios are failing. ")
      notify(false, "Cucumber Failure", summary)
    elsif result.match(/undefined/)
      notify(false, "Cucumber Steps Undefined", "Undefined steps.")
    elsif result.match(/passed/)
      summary.prepend("All scenarios passed. ")
      notify(true, "Cucumber Success", summary)
    end
  else
    puts "#{feature} does not exist."
  end
end

def run_suite
  run_tests('spec', :force)
  #run_feature('features', :force)
end

watch('^spec/(.*/*)_spec\.rb'     ) { |m| run_tests("spec/#{m[1]}_spec.rb")        }
watch('^spec/factories/(.*/*)\.rb') { |m| run_tests("spec/models/#{m[1]}_spec.rb") }
watch('^app/(.*)\.rb'             ) { |m| run_tests("spec/#{m[1]}_spec.rb")        }
watch('^lib/(.*)\.rb'             ) { |m| run_tests("spec/lib/#{m[1]}_spec.rb")    }
watch('^features/.*\.feature'     ) { |m| run_feature(m[0])                        }
watch('^features/.*/.*\.feature'  ) { |m| run_feature(m[0])                        }

@interrupt_received = false

# ^C
Signal.trap 'INT' do
  if @interrupt_received
    exit 0
  else
    @interrupt_received = true
    puts "\nInterrupt a second time to quit"
    Kernel.sleep 1
    @interrupt_received = false
    run_suite
  end
end
