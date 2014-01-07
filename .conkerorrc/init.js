// add directory dir inside .conkerorrc to load_paths
function tmtxt_add_path(dir) {
    let (path = get_home_directory()) {
        path.appendRelativePath(".conkerorrc");
        path.appendRelativePath(dir);
        load_paths.unshift(make_uri(path).spec);
    };
}

/// clear cache function
interactive("tmtxt-cache-clear-all", "clear all cache",
            function (I) {
                cache_clear(CACHE_ALL);
            });
define_key(default_global_keymap, "C-`", "tmtxt-cache-clear-all");

// Load clicked link in background
clicks_in_new_buffer_target = OPEN_NEW_BUFFER_BACKGROUND;

/// open remote url in new tab not new frame
url_remoting_fn = load_url_in_new_buffer;
