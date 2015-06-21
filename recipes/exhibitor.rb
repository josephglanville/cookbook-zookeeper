include_recipe 'zookeeper::java'
include_recipe 'zookeeper::maven'

directory '/opt/exhibitor'

cookbook_file '/opt/exhibitor/pom.xml'

execute 'build-exhibitor' do
  command 'mvn clean package'
  cwd '/opt/exhibitor'
end

cookbook_file '/etc/init/exhibitor.conf' do
  mode 0644
end

link '/opt/exhibitor/exhibitor.jar' do
  to '/opt/exhibitor/target/exhibitor-1.5.5.jar'
end

directory '/etc/exhibitor'

file '/etc/exhibitor/defaults.conf' do
  content node['exhibitor']['defaults'].map { |k, v| "#{k}=#{v}" }.join("\n")
end

cookbook_file '/opt/exhibitor/exhibitor.sh' do
  mode 0755
end

cookbook_file '/etc/exhibitor/web.xml' do
  mode 0600
end
