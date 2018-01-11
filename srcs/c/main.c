/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   main.c                                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: bmoiroud <bmoiroud@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2017/06/23 14:52:43 by bmoiroud          #+#    #+#             */
/*   Updated: 2017/12/21 19:04:16 by eferrand         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "rt.h"

// void		ft_translation(t_vector *pos, int *fd)
// {
// 	t_vector	v;

// 	// v.set = 0;
// 	// if (pos->set == 0)
// 	// 	ft_error(2);
// 	ft_get_coord(&v, fd);
// 	*pos = ft_add_vector(*pos, v);
// }

double	ft_limits(double nb, double min, double max)
{
	if (nb < min)
		return (min);
	else if (nb > max)
		return (max);
	else
		return (nb);
}

int		ft_valid_color(int color)
{
	return (ft_limits(color, 0.0, 255.0));
}

void		print_struct(t_rt rt)
{
	int		i = -1;

	printf("sizeof(t_vector): %zu\n", sizeof(t_vector));
	printf("sizeof(t_object): %zu\n", sizeof(t_object));
	printf("sizeof(t_light): %zu\n", sizeof(t_light));
	printf("sizeof(t_eye): %zu\n", sizeof(t_eye));
	printf("sizeof(t_color): %zu\n", sizeof(t_color));
	printf("sizeof(t_vector): %zu\n", sizeof(t_vector));
	printf("%zu\n\n", sizeof(t_rt));
	printf("------ C -------\n\n");
	printf("cam---------\n\n");
	printf("pos: %f %f %f\n", rt.eye.pos.x, rt.eye.pos.y, rt.eye.pos.z);
	printf("rot: %f %f %f\n", rt.eye.rot.x, rt.eye.rot.y, rt.eye.rot.z);
	printf("fov: %f zoom: %f aspect: %f\n", rt.eye.fov, rt.eye.zoom, rt.eye.aspect);
	printf("effects: %d\n\n", rt.effects);
	printf("objs--------\n\n");
	while (++i < rt.nb_obj)
	{
		printf("id: %d\n", i);
		printf("pos: %f %f %f\n", rt.objects[i].pos.x, rt.objects[i].pos.y, rt.objects[i].pos.z);
		printf("rot: %f %f %f\n", rt.objects[i].rot.x, rt.objects[i].rot.y, rt.objects[i].rot.z);
		printf("size: %f %f %f\n", rt.objects[i].size.x, rt.objects[i].size.y, rt.objects[i].size.z);
		printf("refract: %f reflect: %f spec: %f\n", rt.objects[i].refract, rt.objects[i].reflect, rt.objects[i].spec);
		printf("type: %d\n", rt.objects[i].type);
		printf("perturbation normale: %f\n", rt.objects[i].np);
		printf("texture procedurale: %d\n", rt.objects[i].p_texture);
		printf("color: %d\nrgb: %d %d %d\n\n", rt.objects[i].color.c, rt.objects[i].color.r, rt.objects[i].color.g, rt.objects[i].color.b);
	}
	i = -1;
	printf("lgts--------\n\n");
	while (++i < rt.nb_light)
	{
		printf("id: %d\n", i);
		printf("pos: %f %f %f\n", rt.lights[i].pos.x, rt.lights[i].pos.y, rt.lights[i].pos.z);
		printf("intensity: %f\n\n", rt.lights[i].intensity);
	}
	printf("m[3]--------\n");
	printf("m[i]: %f %f %f\n", rt.m[0].x, rt.m[0].y, rt.m[0].z);
	printf("m[1]: %f %f %f\n", rt.m[1].x, rt.m[1].y, rt.m[1].z);
	printf("m[2]: %f %f %f\n", rt.m[2].x, rt.m[2].y, rt.m[2].z);
	printf("autre-------\n");
	printf("shadows: %d line: %d\n", rt.shadows, rt.line);
	printf("nbl: %d nbo: %d\n", rt.nb_light, rt.nb_obj);
	printf("effects: %d\n", rt.effects);
	printf("\n");
}

static void	main_loop(t_data *data)
{
	int		loop;
	int		i;
	int		j;

	j = data->rt.nb_light;
	i = data->rt.nb_obj;
	loop = 2;
	while (loop)
	{
		if (loop == EVENT_UPDATE)
		{
			// print_struct(data->rt);
			cl_run(&data->cl, (size_t[WORK_DIM]){data->sdl.size.y, data->sdl.size.x}, \
			4, (t_arg){data->sdl.draw_surface->pixels, sizeof(uint32_t) * \
			data->sdl.size.y * data->sdl.size.x, CL_MEM_WRITE_ONLY}, \
			(t_arg){&data->rt, sizeof(t_rt), CL_MEM_READ_ONLY}, \
			(t_arg){&data->keys, sizeof(t_key), CL_MEM_READ_ONLY}, \
			(t_arg){&data->rand, MAX_RAND * sizeof(double), CL_MEM_READ_ONLY});
			sdl_run(&data->sdl);
		}
		loop = sdl_events(&data->sdl, &data->keys, &data->rt);
	}
}

int		main(int ac, char **av)
{
	t_data	data;
	int		i;

	i = -1;
	ft_init_struct(&data);
	if (ac < 2 || ac > 2)
		ft_error(0, 0);
	else if (av[1] == NULL)
		ft_error(1, 0);
	ft_parse(av[1], &data);
	ft_init_data(&data);
	data.rt.eye.aspect = 1.5;
	data.rt.eye.fov = FOV;
	data.rt.eye.zoom = ZOOM;
	data.sdl.size.x = WIN_W;
	data.sdl.size.y = WIN_H;
	data.rt.effects = 1;
	sdl_init(&data.sdl, PROGRAM_NAME);
	cl_init(&data.cl, 0);
	main_loop(&data);
	cl_end(&data.cl);
	sdl_end(&data.sdl);
	return (0);
}
