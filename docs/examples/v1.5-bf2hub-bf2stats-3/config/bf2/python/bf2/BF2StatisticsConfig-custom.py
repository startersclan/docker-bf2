# ------------------------------------------------------------------------------
# BF2Statistics 3.0.0 - Config File
# ------------------------------------------------------------------------------
# Conventions:
#    0 -> Disable
#    1 -> Enable
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# Debug Logging
# ------------------------------------------------------------------------------
debug_enable = 1
debug_log_path = 'python/bf2/logs'		# Relative from BF2 base folder
debug_fraglog_enable = 0				# Detailed 'Fragalyzer' Logs (requires existing folder "mods/<ModName>/logs/")

# ------------------------------------------------------------------------------
# Statistics Enabling
# ------------------------------------------------------------------------------
# 0 = disable statistics, 1 = enable statistics (requires an ASP stats server)
# By disabling the stats, this server will be "non-ranked"
#
# An AuthID and AuthToken are required to post stats data to the ASP backend.
# Contact your local Stats Admin to recieve an AuthID and AuthToken. Both of
# which are NOT to be shared with anyone!
# ------------------------------------------------------------------------------
stats_enable = 1
stats_auth_id = 112960		# Required to post stats data at the end of round.
stats_auth_token = '2GS61JLR2WQq2n6N'	# Required to post stats data at the end of round.

# ------------------------------------------------------------------------------
# ASP Stats Backend Web Server
# ------------------------------------------------------------------------------
http_backend_addr = 'asp.example.com'
http_backend_port = 80
http_backend_asp = '/ASP/bf2statistics.php'

# ------------------------------------------------------------------------------
# Snapshot Logging
# ------------------------------------------------------------------------------
# Enables server to make snapshot backups.
# 0 = log only on error sending to backend
# 1 = all snapshots
# ------------------------------------------------------------------------------
snapshot_logging = 0
snapshot_log_path_sent = 'python/bf2/logs/snapshots/sent' 		# Relative from the BF2 base folder
snapshot_log_path_unsent = 'python/bf2/logs/snapshots/unsent' 	# Relative from the BF2 base folder

# ------------------------------------------------------------------------------
# Medals Processing
# ------------------------------------------------------------------------------
# Suffix for your custom medals file(s).
# Example: A profile named "custom" = medal_data_custom.py
# ------------------------------------------------------------------------------
medals_custom_data = 'custom'
# A list of mods that xpack (special forces) medals can be earned while playing
# Example: ['mods/xpack', 'mods/bf2', 'mods/ModName'] (all entries must be lower case!!)
medals_xpack_mods = ['mods/bf2sfsp','mods/xpack']

# ------------------------------------------------------------------------------
# Player Manager
# ------------------------------------------------------------------------------
# Local IP address for AI Bots
# ------------------------------------------------------------------------------
pm_ai_player_addr = '127.0.0.1'		# Not recommended to change


# ------------------------------------------------------------------------------
# END CONFIGURATION
# ------------------------------------------------------------------------------
