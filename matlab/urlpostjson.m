function [output,status] = urlpostjson(urlChar,data)
% This function requires Java.
if ~usejava('jvm')
   error('MATLAB:urlread:NoJvm','URLREAD requires Java.');
end

import com.mathworks.mlwidgets.io.InterruptibleStreamCopier;

% Be sure the proxy settings are set.
com.mathworks.mlwidgets.html.HTMLPrefs.setProxySettings

% Check number of inputs and outputs.
error(nargchk(1,3,nargin))
error(nargoutchk(0,2,nargout))
if ~ischar(urlChar)
    error('MATLAB:urlread:InvalidInput','The first input, the URL, must be a character array.');
end
if (nargin > 1) && ~ischar(data)
    error('MATLAB:urlpostjson:InvalidInput','Second argument must be a character array.');
end

% Do we want to throw errors or catch them?
if nargout == 2
    catchErrors = true;
else
    catchErrors = false;
end

% Set default outputs.
output = '';
status = 0;

% Create a urlConnection.
[urlConnection,errorid,errormsg] = urlreadwrite(mfilename,urlChar);
if isempty(urlConnection)
    if catchErrors, return
    else error(errorid,errormsg);
    end
end

% POST method.  Write param/values to server.
try
    urlConnection.setDoOutput(true);
    urlConnection.setRequestProperty( ...
        'Content-Type','application/json');
    printStream = java.io.PrintStream(urlConnection.getOutputStream);
    printStream.print(data);
    printStream.close;
catch
    if catchErrors, return
    else error('MATLAB:urlread:ConnectionFailed','Could not POST to URL.');
    end
end


% Read the data from the connection.
try
    inputStream = urlConnection.getInputStream;
    byteArrayOutputStream = java.io.ByteArrayOutputStream;
    % This StreamCopier is unsupported and may change at any time.
    isc = InterruptibleStreamCopier.getInterruptibleStreamCopier;
    isc.copyStream(inputStream,byteArrayOutputStream);
    inputStream.close;
    byteArrayOutputStream.close;
    output = native2unicode(typecast(byteArrayOutputStream.toByteArray','uint8'),'UTF-8');
catch
    if catchErrors, return
    else error('MATLAB:urlread:ConnectionFailed','Error downloading URL. Your network connection may be down or your proxy settings improperly configured.');
    end
end

status = 1;
