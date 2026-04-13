<?php
/**
 * WordPress configuration - credentials loaded from environment variables.
 * Safe to commit: no secrets are hardcoded here.
 */

define('DB_NAME',     getenv('DB_NAME')     ?: 'wordpress');
define('DB_USER',     getenv('DB_USER')     ?: 'wordpress');
define('DB_PASSWORD', getenv('DB_PASSWORD') ?: '');
define('DB_HOST',     getenv('DB_HOST')     ?: 'localhost');
define('DB_CHARSET',  'utf8');
define('DB_COLLATE',  '');

// Security keys — set these as env vars or replace with values from
// https://api.wordpress.org/secret-key/1.1/salt/
define('AUTH_KEY',         getenv('AUTH_KEY')         ?: 'change-me');
define('SECURE_AUTH_KEY',  getenv('SECURE_AUTH_KEY')  ?: 'change-me');
define('LOGGED_IN_KEY',    getenv('LOGGED_IN_KEY')    ?: 'change-me');
define('NONCE_KEY',        getenv('NONCE_KEY')        ?: 'change-me');
define('AUTH_SALT',        getenv('AUTH_SALT')        ?: 'change-me');
define('SECURE_AUTH_SALT', getenv('SECURE_AUTH_SALT') ?: 'change-me');
define('LOGGED_IN_SALT',   getenv('LOGGED_IN_SALT')   ?: 'change-me');
define('NONCE_SALT',       getenv('NONCE_SALT')       ?: 'change-me');

$table_prefix = 'wp_';

define('WP_DEBUG', getenv('WP_DEBUG') === 'true');

// Allow WordPress to detect HTTPS when behind a proxy/load balancer
if (isset($_SERVER['HTTP_X_FORWARDED_PROTO']) && $_SERVER['HTTP_X_FORWARDED_PROTO'] === 'https') {
    $_SERVER['HTTPS'] = 'on';
}

if (!defined('ABSPATH')) {
    define('ABSPATH', __DIR__ . '/');
}

require_once ABSPATH . 'wp-settings.php';
