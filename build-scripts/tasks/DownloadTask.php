<?php

/**
 * WPИ-XM Server Stack
 * Copyright (c) Jens A. Koch <jakoch@web.de>
 * https://wpn-xm.org/
 *
 * Licensed under the MIT License.
 * See the bundled LICENSE file for copyright and license information.
 */

class DownloadTask extends Task
{
    private $registryfolder;
    private $downloadfolder;
    private $wpnxmversion;

    function setRegistryFolder($registryfolder)
    {
        $this->registryfolder = realpath($registryfolder);
    }

    function setDownloadFolder($downloadfolder)
    {
        $this->downloadfolder = realpath($downloadfolder);
    }

    function setWpnxmVersion($wpnxmversion)
    {
        $this->wpnxmversion = $wpnxmversion;
    }

    function main()
    {
        defined('DS') || define('DS', DIRECTORY_SEPARATOR);

        $this->log('Downloading Components using Aria2');

        // get aria download description files
        $files = glob($this->registryfolder . DS . 'downloads-for-{full,literc}-' . $this->wpnxmversion . '*.txt', GLOB_BRACE);

        foreach($files as $file)
        {
            $this->log('Using ' . $file);

           /**
            * Aria2c for parallel downloading
            *
            * https://aria2.github.io/manual/en/html/aria2c.html#example
            * https://aria2.github.io/manual/en/html/aria2c.html#id2
            */
            $aria2_bin = (DS === '/') ? 'aria2c ' : __DIR__ . '\..\..\bin\aria2\aria2c.exe ';

            $aria_cmd = $aria2_bin . ' -i ' . $file
            . ' --disk-cache=0 --max-download-result=0 --check-certificate=false'
            . ' --deferred-input=true --http-accept-gzip=true'
            . ' --split=4 --min-split-size=20M --max-connection-per-server=4 --max-tries=5'
            . ' --conditional-get=true --auto-file-renaming=false'
            . ' --allow-overwrite=false' // default: false. important for skipping files!
            . ' --user-agent="WPN-XM Server Stack Downloader"';
            // --force-sequential=true
            // --user-agent="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2227.0 Safari/537.36"

            passthru($aria_cmd);
        }
    }
}