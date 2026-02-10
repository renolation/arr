import 'package:dio/dio.dart';
import '../../core/network/dio_client.dart';
import 'base_api_service.dart';

/// Supported download client types
enum DownloadClientType {
  qbittorrent,
  transmission,
  sabnzbd,
  nzbget,
  deluge,
  rtorrent,
}

/// Generic API service for download clients
///
/// Provides methods for interacting with various download clients including:
/// - qBittorrent
/// - Transmission
/// - SABnzbd
/// - NZBGet
/// - Deluge
/// - rTorrent
///
/// Note: Different clients may use different authentication methods
/// and API structures. This service provides a generic interface
/// that should be adapted based on the specific client type.
class DownloadApiService extends BaseApiService {
  DownloadClientType clientType;
  final DioClient _dioClient;

  DownloadApiService({
    required super.baseUrl,
    required super.apiKey,
    super.apiBasePath = '',
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Duration? sendTimeout,
    this.clientType = DownloadClientType.qbittorrent,
  })  : _dioClient = DioClient(
          connectTimeout: connectTimeout,
          receiveTimeout: receiveTimeout,
          sendTimeout: sendTimeout,
        ),
        super(
          connectTimeout: connectTimeout,
          receiveTimeout: receiveTimeout,
          sendTimeout: sendTimeout,
        );

  /// Configure client with username/password authentication
  ///
  /// Some clients use username/password instead of API keys.
  /// This method updates the authentication header accordingly.
  void configureWithCredentials({
    required String baseUrl,
    required String username,
    required String password,
  }) {
    // Update base URL
    _dioClient.setBaseUrl(baseUrl);

    // Note: Each client has different auth methods
    // qBittorrent uses session cookies from /api/v2/auth/login
    // Transmission uses Basic Auth
    // SABnzbd uses API key in URL params
    // Implementation would need to be client-specific
  }

  /// Get current download queue
  ///
  /// Returns information about items currently in the queue including:
  /// - Download progress
  /// - ETA
  /// - Download/upload speeds
  /// - File information
  ///
  /// Note: Response structure varies by client type.
  Future<Response> getQueue() async {
    switch (clientType) {
      case DownloadClientType.qbittorrent:
        return await get('/api/v2/torrents/info');
      case DownloadClientType.transmission:
        return await get('/transmission/rpc', queryParameters: {
          'method': 'torrent-get',
          'arguments': {'fields': 'torrents'},
        });
      case DownloadClientType.sabnzbd:
        return await get('/api', queryParameters: {
          'mode': 'queue',
          'output': 'json',
        });
      case DownloadClientType.nzbget:
        return await post('/jsonrpc', data: {
          'jsonrpc': '2.0',
          'method': 'listgroups',
          'id': 1,
        });
      case DownloadClientType.deluge:
        return await post('/json', data: {
          'method': 'core.get_torrents_status',
          'params': [{}, []],
          'id': 1,
        });
      case DownloadClientType.rtorrent:
        return await get('', queryParameters: {
          'mode': 'list',
        });
    }
  }

  /// Get download history
  ///
  /// Returns completed downloads and their status.
  Future<Response> getHistory() async {
    switch (clientType) {
      case DownloadClientType.qbittorrent:
        // qBittorrent uses "completed" filter for history
        return await get('/api/v2/torrents/info', queryParameters: {
          'filter': 'completed',
        });
      case DownloadClientType.transmission:
        return await get('/transmission/rpc', queryParameters: {
          'method': 'torrent-get',
          'arguments': {'fields': 'torrents'},
        });
      case DownloadClientType.sabnzbd:
        return await get('/api', queryParameters: {
          'mode': 'history',
          'output': 'json',
        });
      case DownloadClientType.nzbget:
        return await post('/jsonrpc', data: {
          'jsonrpc': '2.0',
          'method': 'history',
          'id': 1,
        });
      case DownloadClientType.deluge:
        return await post('/json', data: {
          'method': 'core.get_torrents_status',
          'params': [{}, []],
          'id': 1,
        });
      case DownloadClientType.rtorrent:
        return await get('', queryParameters: {
          'mode': 'list',
        });
    }
  }

  /// Pause a specific download
  ///
  /// Parameters:
  /// - [id]: The ID or hash of the download to pause
  ///
  /// Note: The [id] parameter varies by client (hash, ID, etc.)
  Future<Response> pauseDownload(String id) async {
    switch (clientType) {
      case DownloadClientType.qbittorrent:
        return await get('/api/v2/torrents/pause', queryParameters: {
          'hashes': id,
        });
      case DownloadClientType.transmission:
        return await get('/transmission/rpc', queryParameters: {
          'method': 'torrent-stop',
          'arguments': {'ids': [id]},
        });
      case DownloadClientType.sabnzbd:
        return await get('/api', queryParameters: {
          'mode': 'queue',
          'name': 'pause',
          'value': id,
          'output': 'json',
        });
      case DownloadClientType.nzbget:
        return await post('/jsonrpc', data: {
          'jsonrpc': '2.0',
          'method': 'group.pause',
          'params': [id],
          'id': 1,
        });
      case DownloadClientType.deluge:
        return await post('/json', data: {
          'method': 'core.pause_torrent',
          'params': [[id]],
          'id': 1,
        });
      case DownloadClientType.rtorrent:
        return await get('', queryParameters: {
          'mode': 'pause',
          'hash': id,
        });
    }
  }

  /// Resume a paused download
  ///
  /// Parameters:
  /// - [id]: The ID or hash of the download to resume
  Future<Response> resumeDownload(String id) async {
    switch (clientType) {
      case DownloadClientType.qbittorrent:
        return await get('/api/v2/torrents/resume', queryParameters: {
          'hashes': id,
        });
      case DownloadClientType.transmission:
        return await get('/transmission/rpc', queryParameters: {
          'method': 'torrent-start',
          'arguments': {'ids': [id]},
        });
      case DownloadClientType.sabnzbd:
        return await get('/api', queryParameters: {
          'mode': 'queue',
          'name': 'resume',
          'value': id,
          'output': 'json',
        });
      case DownloadClientType.nzbget:
        return await post('/jsonrpc', data: {
          'jsonrpc': '2.0',
          'method': 'group.resume',
          'params': [id],
          'id': 1,
        });
      case DownloadClientType.deluge:
        return await post('/json', data: {
          'method': 'core.resume_torrent',
          'params': [[id]],
          'id': 1,
        });
      case DownloadClientType.rtorrent:
        return await get('', queryParameters: {
          'mode': 'resume',
          'hash': id,
        });
    }
  }

  /// Remove a download
  ///
  /// Parameters:
  /// - [id]: The ID or hash of the download to remove
  /// - [deleteFiles]: Whether to delete the downloaded files (default: false)
  Future<Response> removeDownload(
    String id, {
    bool deleteFiles = false,
  }) async {
    switch (clientType) {
      case DownloadClientType.qbittorrent:
        return await get('/api/v2/torrents/delete', queryParameters: {
          'hashes': id,
          'deleteFiles': deleteFiles,
        });
      case DownloadClientType.transmission:
        return await get('/transmission/rpc', queryParameters: {
          'method': 'torrent-remove',
          'arguments': {
            'ids': [id],
            'delete-local-data': deleteFiles,
          },
        });
      case DownloadClientType.sabnzbd:
        return await get('/api', queryParameters: {
          'mode': 'queue',
          'name': 'delete',
          'value': id,
          'delete_files': deleteFiles,
          'output': 'json',
        });
      case DownloadClientType.nzbget:
        return await post('/jsonrpc', data: {
          'jsonrpc': '2.0',
          'method': deleteFiles ? 'group.delete' : 'group.finalize',
          'params': [id],
          'id': 1,
        });
      case DownloadClientType.deluge:
        return await post('/json', data: {
          'method': deleteFiles
              ? 'core.remove_torrent'
              : 'core.remove_torrents',
          'params': [
            [id],
            deleteFiles,
          ],
          'id': 1,
        });
      case DownloadClientType.rtorrent:
        return await get('', queryParameters: {
          'mode': 'delete',
          'hash': id,
          'deleteFiles': deleteFiles,
        });
    }
  }

  /// Pause all downloads
  Future<Response> pauseAll() async {
    switch (clientType) {
      case DownloadClientType.qbittorrent:
        return await get('/api/v2/torrents/pause', queryParameters: {
          'hashes': 'all',
        });
      case DownloadClientType.transmission:
        return await get('/transmission/rpc', queryParameters: {
          'method': 'torrent-stop',
          'arguments': {},
        });
      case DownloadClientType.sabnzbd:
        return await get('/api', queryParameters: {
          'mode': 'pause',
          'output': 'json',
        });
      case DownloadClientType.nzbget:
        return await post('/jsonrpc', data: {
          'jsonrpc': '2.0',
          'method': 'pause',
          'id': 1,
        });
      case DownloadClientType.deluge:
        return await post('/json', data: {
          'method': 'core.pause_all_torrents',
          'params': [],
          'id': 1,
        });
      case DownloadClientType.rtorrent:
        return await get('', queryParameters: {
          'mode': 'pauseall',
        });
    }
  }

  /// Resume all downloads
  Future<Response> resumeAll() async {
    switch (clientType) {
      case DownloadClientType.qbittorrent:
        return await get('/api/v2/torrents/resume', queryParameters: {
          'hashes': 'all',
        });
      case DownloadClientType.transmission:
        return await get('/transmission/rpc', queryParameters: {
          'method': 'torrent-start',
          'arguments': {},
        });
      case DownloadClientType.sabnzbd:
        return await get('/api', queryParameters: {
          'mode': 'resume',
          'output': 'json',
        });
      case DownloadClientType.nzbget:
        return await post('/jsonrpc', data: {
          'jsonrpc': '2.0',
          'method': 'resume',
          'id': 1,
        });
      case DownloadClientType.deluge:
        return await post('/json', data: {
          'method': 'core.resume_all_torrents',
          'params': [],
          'id': 1,
        });
      case DownloadClientType.rtorrent:
        return await get('', queryParameters: {
          'mode': 'resumeall',
        });
    }
  }

  /// Get download speed
  ///
  /// Returns current download speed in bytes per second.
  Future<Response> getDownloadSpeed() async {
    switch (clientType) {
      case DownloadClientType.qbittorrent:
        return await get('/api/v2/transfer/info');
      case DownloadClientType.transmission:
        return await get('/transmission/rpc', queryParameters: {
          'method': 'session-stats',
          'arguments': {},
        });
      case DownloadClientType.sabnzbd:
        return await get('/api', queryParameters: {
          'mode': 'queue',
          'output': 'json',
        });
      case DownloadClientType.nzbget:
        return await post('/jsonrpc', data: {
          'jsonrpc': '2.0',
          'method': 'status',
          'id': 1,
        });
      case DownloadClientType.deluge:
        return await post('/json', data: {
          'method': 'core.get_session_status',
          'params': [['download_rate', 'upload_rate']],
          'id': 1,
        });
      case DownloadClientType.rtorrent:
        return await get('', queryParameters: {
          'mode': 'speed',
        });
    }
  }

  /// Get session information
  ///
  /// Returns session/connection information for the client.
  Future<Response> getSession() async {
    switch (clientType) {
      case DownloadClientType.qbittorrent:
        return await get('/api/v2/transfer/info');
      case DownloadClientType.transmission:
        return await get('/transmission/rpc', queryParameters: {
          'method': 'session-get',
          'arguments': {},
        });
      case DownloadClientType.sabnzbd:
        return await get('/api', queryParameters: {
          'mode': 'status',
          'output': 'json',
        });
      case DownloadClientType.nzbget:
        return await post('/jsonrpc', data: {
          'jsonrpc': '2.0',
          'method': 'status',
          'id': 1,
        });
      case DownloadClientType.deluge:
        return await post('/json', data: {
          'method': 'web.get_ui',
          'params': [],
          'id': 1,
        });
      case DownloadClientType.rtorrent:
        return await get('', queryParameters: {
          'mode': 'view',
          'view': 'main',
        });
    }
  }

  /// Add a torrent/magnet link
  ///
  /// Parameters:
  /// - [url]: The torrent URL or magnet link
  /// - [savePath]: Optional save path for the download
  Future<Response> addTorrent(
    String url, {
    String? savePath,
  }) async {
    switch (clientType) {
      case DownloadClientType.qbittorrent:
        return await post('/api/v2/torrents/add', data: {
          'urls': url,
          if (savePath != null) 'savepath': savePath,
        });
      case DownloadClientType.transmission:
        return await get('/transmission/rpc', queryParameters: {
          'method': 'torrent-add',
          'arguments': {
            'filename': url,
            if (savePath != null) 'download-dir': savePath,
          },
        });
      case DownloadClientType.sabnzbd:
        return await get('/api', queryParameters: {
          'mode': 'addurl',
          'name': url,
          if (savePath != null) 'dir': savePath,
          'output': 'json',
        });
      case DownloadClientType.nzbget:
        return await post('/jsonrpc', data: {
          'jsonrpc': '2.0',
          'method': 'appendurl',
          'params': [url, savePath ?? ''],
          'id': 1,
        });
      case DownloadClientType.deluge:
        return await post('/json', data: {
          'method': 'core.add_torrent_url',
          'params': [url, [], {}],
          'id': 1,
        });
      case DownloadClientType.rtorrent:
        return await get('', queryParameters: {
          'mode': 'load',
          'url': url,
          if (savePath != null) 'directory': savePath,
        });
    }
  }

  /// Get client version
  ///
  /// Returns version information for the download client.
  Future<Response> getVersion() async {
    switch (clientType) {
      case DownloadClientType.qbittorrent:
        return await get('/api/v2/app/version');
      case DownloadClientType.transmission:
        return await get('/transmission/rpc', queryParameters: {
          'method': 'session-get',
          'arguments': {},
        });
      case DownloadClientType.sabnzbd:
        return await get('/api', queryParameters: {
          'mode': 'version',
          'output': 'json',
        });
      case DownloadClientType.nzbget:
        return await post('/jsonrpc', data: {
          'jsonrpc': '2.0',
          'method': 'version',
          'id': 1,
        });
      case DownloadClientType.deluge:
        return await post('/json', data: {
          'method': 'daemon.get_version',
          'params': [],
          'id': 1,
        });
      case DownloadClientType.rtorrent:
        return await get('', queryParameters: {
          'mode': 'version',
        });
    }
  }

  /// Test connection to the download client
  @override
  Future<bool> testConnection() async {
    try {
      final response = await getVersion();
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
