Ext.define ('Earsip.controller.WinUpload', {
	extend	: 'Ext.app.Controller'
,	refs	: [{
		ref		: 'winupload'
	,	selector: 'winupload'
	},{
		ref		: 'dirlist'
	,	selector: 'dirlist'
	}]
,	init	: function ()
	{
		this.control ({
			'winupload button[action=upload]': {
				click: this.do_upload
			}
		});
	}

,	do_upload : function (button)
	{
		var win		= this.getWinupload ();
		var panel	= win.down ('form');
		var form	= panel.getForm ();

		if (form.isValid ()) {
			var name = panel.getComponent ('fileupload').getValue ();
			if (name == "") {
				return;
			}
			var s = name.lastIndexOf ("\\");
			if (s > 0) {
				name = name.substring (s + 1);
			}

			form.submit ({
				url		: 'data/upload.jsp'
			,	params	: {
					dir_id	: Earsip.dir_id
				,	path	: Earsip.tree_path
				,	name	: name
				}
			,	scope	: this
			,	waitMsg	: 'Mengunggah berkas anda ...'
			,	success	: function (fp, o)
				{
					Ext.Msg.alert ('Unggah', o.result.info);
					this.getDirlist ().do_load_list (Earsip.dir_id);
				}
			});
		}
	}
});