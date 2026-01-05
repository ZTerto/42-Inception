<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the installation.
 * You don't have to use the web site, you can copy this file to "wp-config.php"
 * and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * Database settings
 * * Secret keys
 * * Database table prefix
 * * Localized language
 * * ABSPATH
 *
 * @link https://wordpress.org/support/article/editing-wp-config-php/
 *
 * @package WordPress
 */

// ** Database settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'wordpress' );

/** Database username */
define( 'DB_USER', 'wp_user' );

/** Database password */
define( 'DB_PASSWORD', 'wp_pass' );

/** Database hostname */
define( 'DB_HOST', 'mariadb:3306' );

/** Database charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8' );

/** The database collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication unique keys and salts.
 *
 * Change these to different unique phrases! You can generate these using
 * the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}.
 *
 * You can change these at any point in time to invalidate all existing cookies.
 * This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define( 'AUTH_KEY',          'F>!Enjpfi[d=~C5rb;6qc|va;C(6zzwx}K7di&YKOD|:}w[W`,^oBm3F8wMWTuQd' );
define( 'SECURE_AUTH_KEY',   '/ij5Fb6VoeU?T#(v1kjAAy+/}YsCytJw0V{ms Td]cbq1HG$78{ t9[dp^EdJ VE' );
define( 'LOGGED_IN_KEY',     'WI8xh^Ocqh<H8*v~2;FN}?8xwd$HjC0&I5(smm aw2&0s74[PWE$aeHKs&f*L9R0' );
define( 'NONCE_KEY',         'kZ]^biw~o9{n4Z8MFIG4nRRufOY?g=c?CZaxZ~EB)*&*?2eFeBei,7#GNpSk=f3D' );
define( 'AUTH_SALT',         'V]@Q4Q< E>JLGB* re(}XFU11>9y8xs41SgX6?l_1n{8,?n;a?(V5?_:!*(s{2d<' );
define( 'SECURE_AUTH_SALT',  'NB!no4R@*ruHbh}5cBLsK7ga%L9!CWA&?A-u-m6*:bAJP{e)llambdNzXI(7,X4x' );
define( 'LOGGED_IN_SALT',    '+D2zb8qDzl_o2B/1Qn)!+x^:,]2Y&k{~]u39=:wB^a.Sp9hl>e4^x>`K=VmjkwBS' );
define( 'NONCE_SALT',        '@<{r,~4~si~y}eb3}iI,R:G^Ii@Ir1V3:H#YDN6<a7@#Q^4<jmW%fHuw4nzNMk.1' );
define( 'WP_CACHE_KEY_SALT', 'yU*.RV3h)T_PWR0-G`-gz}vtqKM&qKruh&0,TxJ;g44vFGd !I-U#b]I%Inc8(]%' );


/**#@-*/

/**
 * WordPress database table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix = 'wp_';


/* Add any custom values between this line and the "stop editing" line. */



/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the documentation.
 *
 * @link https://wordpress.org/support/article/debugging-in-wordpress/
 */
if ( ! defined( 'WP_DEBUG' ) ) {
	define( 'WP_DEBUG', false );
}

/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';
