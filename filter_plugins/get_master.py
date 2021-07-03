#!/usr/bin/python
class FilterModule(object):
    def filters(self):
        return {
            'get_kubernetes_master': self.get_kubernetes_master,
        }

    def get_kubernetes_master(self, hostvars, cluster_name):
        result = None
        for i in hostvars:
          for j in i.get('value').get('apps').items():
            if j[1].get('kubernetes',{}).get('configs',{}).get('cluster_name') == cluster_name and \
               j[1].get('kubernetes',{}).get('configs',{}).get('type') == "master":
                result = j[1]
                break
        return result
