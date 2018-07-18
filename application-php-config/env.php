<?php
return array (
  'session' => 
  array (
    'save' => 'files',
  ),
  'cache' => 
  array (
    'frontend' => 
    array (
      'default' => 
      array (
        'backend' => 'Cm_Cache_Backend_Redis',
        'backend_options' => 
        array (
          'server' => 'cacheredisslave',
          'port' => '6379',
          'database' => '0',
        ),
      ),
    ),
  ),
  'backend' => 
  array (
    'frontName' => 'mgadmin',
  ),
  'crypt' => 
  array (
    'key' => '19db0517bebece5e7c0eddbc7f11e04c',
  ),
  'db' => 
  array (
    'table_prefix' => '',
    'connection' => 
    array (
      'default' => 
      array (
        'host' => 'dbnodegalera',
        'dbname' => 'germantom',
        'username' => 'magento2',
        'password' => 'RagRX9ZZ570jsjIDqFqeTMBEPpC/uKalssK+TR544ck=',
        'active' => '1',
      ),
    ),
  ),
  'resource' => 
  array (
    'default_setup' => 
    array (
      'connection' => 'default',
    ),
  ),
  'x-frame-options' => 'SAMEORIGIN',
  'MAGE_MODE' => 'developer',
  'cache_types' => 
  array (
    'config' => 1,
    'layout' => 1,
    'block_html' => 1,
    'collections' => 1,
    'reflection' => 1,
    'db_ddl' => 1,
    'eav' => 1,
    'customer_notification' => 1,
    'full_page' => 1,
    'config_integration' => 1,
    'config_integration_api' => 1,
    'translate' => 1,
    'config_webservice' => 1,
    'compiled_config' => 1,
  ),
  'install' => 
  array (
    'date' => 'Thu, 12 Apr 2018 12:44:33 +0000',
  ),
);
