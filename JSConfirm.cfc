component mixin="controller" {

	public any function init() {
		this.version = "2.0";
		return this;
	}

  /**
	 * Override core linkTo(), call it and then act on the result.
	 */
  public string function linkTo() {
		local.confirm = $jsConfirmArgs(args=arguments);
		local.rv = core.linkTo(argumentCollection=arguments);
		local.rv = $jsConfirmAdd(name="onclick", rv=local.rv, confirm=local.confirm);
		return local.rv;
  }

  /**
	 * Override core buttonTo(), call it and then act on the result.
	 */
  public string function buttonTo() {
		local.confirm = $jsConfirmArgs(args=arguments);
		local.rv = core.buttonTo(argumentCollection=arguments);
		local.rv = $jsConfirmAdd(name="onsubmit", rv=local.rv, confirm=local.confirm);
		return local.rv;
  }

  /**
	 * Delete the "confirm" argument from the arguments struct so it doesn't get passed along to linkTo() / buttonTo().
	 * This works because the arguments struct is passed in by reference.
	 * Also return the "confirm" argument as a blank string, or what was passed in to it originally.
	 */
	public string function $jsConfirmArgs(required struct args) {
		local.rv = "";
    if (StructKeyExists(args, "confirm")) {
			local.rv = args.confirm;
			StructDelete(args, "confirm");
		}
		return local.rv;
  }

  /**
	 * Add the attribute to the string (e.g., "onsubmit", "onclick").
	 */
  public string function $jsConfirmAdd(required string name, required string rv, required string confirm) {
		if (Len(arguments.confirm)) {
			local.pos = Find(">", arguments.rv) - 1;
			local.attribute = " #arguments.name#=""return confirm('#JSStringFormat(arguments.confirm)#');""";
			local.rv = Insert(local.attribute, arguments.rv, local.pos);
		} else {
			local.rv = arguments.rv;
		}
		return local.rv;
  }

}