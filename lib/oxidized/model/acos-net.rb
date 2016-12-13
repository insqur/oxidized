class ACOS < Oxidized::Model
  # A10 ACOS model for AX and Thunder series

  comment  '! '

  ##ACOS prompt changes depending on the state of the device
  prompt /^([-\w.\/:?\[\]\(\)]+[#>]\s?)$/

  cmd :secret do |cfg|
    cfg.gsub!(/community read encrypted (\S+)/, 'community read encrypted <hidden>') # snmp
    cfg.gsub!(/secret encrypted (\S+)/, 'secret encrypted <hidden>') # tacacs-server
    cfg.gsub!(/password encrypted (\S+)/, 'password encrypted <hidden>') # user
    cfg
  end

  cmd 'show version' do |cfg|
    cfg.gsub! /\s(Last configuration saved at).*/, ' \\1 <removed>'
    cfg.gsub! /\s(Memory).*/, ' \\1 <removed>'
    cfg.gsub! /\s(Current time is).*/, ' \\1 <removed>'
    cfg.gsub! /\s(The system has been up).*/, ' \\1 <removed>'
    comment cfg
  end

  cmd 'show bootimage' do |cfg|
    comment cfg
  end

  cmd 'show license' do |cfg|
    comment cfg
  end

  cmd 'show partition-config all' do |cfg|
     cfg.gsub! /(Current configuration).*/, '\\1 <removed>'
     cfg.gsub! /(Configuration last updated at).*/, '\\1 <removed>'
     cfg.gsub! /(Configuration last saved at).*/, '\\1 <removed>'
     cfg.gsub! /(Configuration last synchronized at).*/, '\\1 <removed>'
     cfg
  end  

  cmd 'show running-config all-partitions' do |cfg|
     cfg.gsub! /(Current configuration).*/, '\\1 <removed>'
     cfg.gsub! /(Configuration last updated at).*/, '\\1 <removed>'
     cfg.gsub! /(Configuration last saved at).*/, '\\1 <removed>'
     cfg.gsub! /(Configuration last synchronized at).*/, '\\1 <removed>'
     cfg
  end

  cmd 'show aflex all-partitions' do |cfg|
    comment cfg
  end


  cfg :telnet do
    username  /login:/
    password  /^Password:/
  end
  
  cfg :telnet, :ssh do
    # preferred way to handle additional passwords
    post_login do
      pw = vars(:enable)
      pw ||= ""
      send "enable\r\n"
      cmd pw
    end
    post_login 'terminal length 0'
    post_login 'terminal width 0'
    pre_logout "exit\nexit\nY\r\n"
  end
end
