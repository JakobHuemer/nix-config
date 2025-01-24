{ pkgs, vars, ... }:

{
  programs.nvf = {
	  enable = true;
		settings = {
      vim = {
			  theme = { 
			    enable = true;
			    name = "catppuccin";
			    style = "mocha";
			  };

				filetree.nvimTree = {
          enable = true;

					mappings.focus = "<leader>e";
					mappings.toggle = "<leader>t";
				};


        statusline.lualine.enable = true;
				telescope.enable = true;
				autocomplete.nvim-cmp.enable = true;
			 
        mini = {
          indentscope.enable = true;
					fuzzy.enable = true;
				};

				options = {
          autoindent = true;
					tabstop = 2;
				};
        
				visuals = {
          indent-blankline = {
            enable = true;
					};
				};

				treesitter = {
				  enable = true;
					highlight.enable = true;
					indent.enable = true;
				};

			  languages = {
          enableLSP = true;
					enableTreesitter = true;
          
					gleam.enable = true;
          zig.enable = true;
					html.enable = true;
					markdown.enable = true;
					python.enable = true;
					clang.enable = true;
					nix.enable = true;
					rust.enable = true;
					ts.enable = true;
				};

			};
		};

	};
}
