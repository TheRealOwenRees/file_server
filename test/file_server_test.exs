defmodule FileServerTest do
  use ExUnit.Case
  doctest FileServer

  test "PlantID - Delete non-existing image" do
    assert {:error, _} = FileServer.PlantId.delete_image("nonexisting.jpg")
  end

  test "PlantID - Download non-existing file" do
    image_url =
      "https://camo.githubusercontent.com/c2fd2f94aa555901aedb2eec8e3535243452b43646eb8086efe1a/6852d696d616765732f696d6167652d34342e6a7067"

    assert {:error, 403} = FileServer.PlantId.get_image(image_url)
  end

  test "PlantID - Download and save file as timestamp, then delete file" do
    image_url =
      "https://camo.githubusercontent.com/c2fd2f94aa55544327fc8ed8901aedb2eec8e3535243452b43646eb8086efe1a/68747470733a2f2f796176757a63656c696b65722e6769746875622e696f2f73616d706c652d696d616765732f696d6167652d34342e6a7067"

    assert {:ok, filename} = FileServer.PlantId.get_image(image_url)
    assert FileServer.PlantId.image_exists?(filename)

    FileServer.PlantId.delete_image(filename)
    refute FileServer.PlantId.image_exists?(filename)
  end
end
