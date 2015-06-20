directory '/opt/exhibitor'
directory '/etc/exhibitor/handlers.d' do
  recursive true
end

cookbook_file '/opt/exhibitor/discovery.rb'
cookbook_file '/opt/exhibitor/discovery' do
  source 'discovery.sh'
  mode 0755
end

cookbook_file '/etc/init/exhibitor-discovery.conf' do
  mode 0644
end

file '/etc/init/exhibitor-discovery.override' do
  content 'manual'
  not_if node['exhibitor']['discovery']['enabled']
end
