import configparser

def get_proc_config():
    conf = {}
    cfg = configparser.ConfigParser()
    cfg.read('proc.conf')
    for (key,val) in cfg.items('PROC_APP_CONFIGS'):
        conf[key]=val
    return conf
