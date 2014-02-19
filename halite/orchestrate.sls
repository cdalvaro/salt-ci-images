
deploy-master:
  salt.state:
    - tgt: {{ grains.get('id') }}
    - sls:
      - halite.master.deploy


configure-master:
  salt.state:
    - tgt: 'test-halite-master-*'
    - sls:
      - halite.master.config
      - halite.master.setup-halite
    - require:
      - salt: deploy-master


deploy-minions:
  salt.state:
    - tgt: {{ grains.get('id') }}
    - sls:
      - halite.minions.deploy

accept-minion-keys:
  salt.state:
    - tgt: 'test-halite-master-*'
    - sls:
      - halite.master.accept-keys
    - require:
      - salt: deploy-minions


configure-minions:
  salt.state:
    - tgt: 'test-halite-minion-*'
    - sls:
      - apache
    - require:
      - salt: accept-minion-keys
