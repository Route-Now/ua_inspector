defmodule UAInspector.Database.VendorFragments do
  @moduledoc """
  UAInspector vendor fragment information database.
  """

  use UAInspector.Database,
    ets_prefix: :ua_inspector_db_vendor_fragments,
    sources: [{"", "vendorfragments.yml"}],
    type: :vendor_fragment

  alias UAInspector.Util

  def to_ets({brand, regexes}, _type) do
    regexes = regexes |> Enum.map(&Util.build_regex/1)

    %{
      brand: brand,
      regexes: regexes
    }
  end
end
