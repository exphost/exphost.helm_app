kubectl = {}
def kubectl_cmd(host, cmd):
    if not kubectl.get((host,cmd)):
        kubectl[(host,cmd)] = host.ansible(
          "command",
          "/var/lib/rancher/rke2/bin/kubectl --kubeconfig /etc/rancher/rke2/rke2.yaml {command}".format(command=cmd),
          become=True,
          become_user="root",
          check=False,
        )
    return kubectl[(host,cmd)]
def test_nodes_count(host):
    assert len(kubectl_cmd(host, "get nodes")['stdout_lines']) == 2+1

def test_nodes_ready(host):
    assert "NotReady" not in kubectl_cmd(host, "get nodes")['stdout']

def test_nginx_is_working(host):
    service_ip = kubectl_cmd(host, "-n simple-nginx get service www1-nginx -o jsonpath='{.spec.clusterIP}'")['stdout']
    assert service_ip
    assert "the nginx web server is successfully installed" in host.check_output("curl http://{ip}:8090".format(ip=service_ip))

