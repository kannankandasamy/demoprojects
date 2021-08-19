import configparser

def get_proc_config(cnf='proc.conf', itm='SNOW_APP_CONFIGS'):
    conf = {}
    cfg = configparser.ConfigParser()
    cfg.read('snow.conf')
    for (key,val) in cfg.items('SNOW_APP_CONFIGS'):
        conf[key]=val
    return conf
