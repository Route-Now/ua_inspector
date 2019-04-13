defmodule UAInspector.ShortCodeMap.OSs do
  @moduledoc false

  use UAInspector.ShortCodeMap,
    ets_prefix: :ua_inspector_scm_oss

  def file_local, do: "short_codes.oss.yml"
  def file_remote, do: Config.database_url(:short_code_map, "Parser/OperatingSystem.php")
  def to_ets([{short, long}]), do: {short, long}
  def var_name, do: "operatingSystems"
  def var_type, do: :hash
end
