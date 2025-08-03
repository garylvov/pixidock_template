import pytest


@pytest.mark.timeout(90)
def test_genesis_scene():
    """Test that genesis can be imported and a scene can be created."""
    try:
        import genesis as gs
        import torch

        if torch.cuda.is_available():
            gs.init(backend=gs.gpu)
        else:
            gs.init(backend=gs.cpu)

        # Taken from https://genesis-world.readthedocs.io/en/latest/user_guide/getting_started/visualization.html
        # https://genesis-world.readthedocs.io/en/latest/user_guide/getting_started/control_your_robot.html
        scene = gs.Scene(
            show_viewer=False,
            viewer_options=gs.options.ViewerOptions(
                res=(1280, 960),
                camera_pos=(3.5, 0.0, 2.5),
                camera_lookat=(0.0, 0.0, 0.5),
                camera_fov=40,
                max_FPS=60,
            ),
            vis_options=gs.options.VisOptions(
                show_world_frame=True,  # visualize the coordinate frame of `world` at its origin
                world_frame_size=1.0,  # length of the world frame in meter
                show_link_frame=False,  # do not visualize coordinate frames of entity links
                show_cameras=False,  # do not visualize mesh and frustum of the cameras added
                plane_reflection=True,  # turn on plane reflection
                ambient_light=(0.1, 0.1, 0.1),  # ambient light setting
            ),
            renderer=gs.renderers.Rasterizer(),  # using rasterizer for camera rendering
        )

        plane = scene.add_entity(
            gs.morphs.Plane(),
        )

        # when loading an entity, you can specify its pose in the morph.
        franka = scene.add_entity(
            gs.morphs.MJCF(
                file="xml/franka_emika_panda/panda.xml",
                pos=(1.0, 1.0, 0.0),
                euler=(0, 0, 0),
            ),
        )

        cam = scene.add_camera(
            res=(1280, 960), pos=(3.5, 0.0, 2.5), lookat=(0, 0, 0.5), fov=30, GUI=False
        )
        scene.build()

        # render rgb, depth, segmentation mask and normal map
        rgb, depth, segmentation, normal = cam.render(
            depth=True, segmentation=True, normal=True
        )

    except ImportError:
        pytest.skip("Genesis or PyTorch not installed - skipping ")

    assert True


if __name__ == "__main__":
    pytest.main([__file__, "-v", "--tb=short"])
