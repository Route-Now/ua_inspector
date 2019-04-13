defmodule UAInspector.ShortCodeMap.DesktopFamilies do
  @moduledoc false

  use UAInspector.ShortCodeMap,
    ets_prefix: :ua_inspector_scm_desktop_families

  def file_local, do: "short_codes.desktop_families.yml"
  def file_remote, do: Config.database_url(:short_code_map, "DeviceDetector.php")
  def to_ets(item), do: {item}
  def var_name, do: "desktopOsArray"
  def var_type, do: :list
end
