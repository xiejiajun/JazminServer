/**
 * 
 */
package jazmin.server.cdn;

import io.netty.channel.Channel;
import io.netty.handler.codec.http.DefaultHttpRequest;

/**
 * @author yama
 *
 */
public class FileUpload extends FileOpt{

	public FileUpload(CdnServer cdnServer, String uri, Channel channel,
			DefaultHttpRequest httpRequest) {
		super(cdnServer, uri, channel, httpRequest);
		sourceType=TYPE_UPLOAD_FILE;
	}
	//
	void close()throws Exception{
		cdnServer.removeFileRequest(this.id);
	}
}
