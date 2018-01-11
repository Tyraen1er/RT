/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   rt.cl                                              :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: bmoiroud <bmoiroud@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2017/06/30 15:20:24 by bmoiroud          #+#    #+#             */
/*   Updated: 2017/12/09 13:46:59 by bmoiroud         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "rt.h.cl"
#include "light.cl"
#include "texture.cl"
#include "collision.cl"
#include "reflection.cl"

static void		put_pixel(__global uint* pixels, const t_yx pixel, \
											const t_yx size, const int color, const t_ray ray)
{
	pixels[pixel.x + pixel.y * size.x] = color;
	
}

static t_ray	ft_init_ray(__global t_rt *rt, const t_yx coords, const t_yx size)
{
	t_ray			ray;
	const double	a = (WIN_W - ((double)(coords.x + 546) * rt->eye.fov)) / \
																		WIN_H;
	const double	b = (WIN_H - ((double)(coords.y + 109) * (rt->eye.fov * \
													rt->eye.aspect))) / WIN_W;

	ray.id = -1;
	ray.t = 200000.0;
	ray.dist = 200000.0;
	ray.bounces = MAX_BOUNCES;
	ray.dir = normalize((t_vector){a * rt->m[1].x + b * rt->m[2].x + \
		rt->eye.zoom * rt->m[0].x, a * rt->m[1].y + b * rt->m[2].y + \
		rt->eye.zoom * rt->m[0].y, a * rt->m[1].z + b * rt->m[2].z + \
		rt->eye.zoom * rt->m[0].z});
	ray.pos = rt->eye.pos;
	return (ray);
}

static t_color	ft_color(__global t_rt *rt, const t_ray ray, const double l, __constant double *rand)
{
	t_color	c;
	int		color = (ray.id < rt->nb_obj) ? rt->objects[ray.id].color.c : -1;
	
	if (rt->objects[ray.id].p_texture != 0 && rt->effects)
		color = ft_procedural_texture(rt, ray, &rt->objects[ray.id], rand).c;
	c.b = min(max(min(max((color >> 16 & 0xff) * l, 0.0), 255.0) + \
						min(max(255.0 * (l - 1.0), 0.0), 255.0), 0.0), 255.0);
	c.g = min(max(min(max((color >> 8 & 0xff) * l, 0.0), 255.0) + \
						min(max(255.0 * (l - 1.0), 0.0), 255.0), 0.0), 255.0);
	c.r = min(max(min(max((color & 0xff) * l, 0.0), 255.0) + \
						min(max(255.0 * (l - 1.0), 0.0), 255.0), 0.0), 255.0);
	c.c = 0xff << 24 | c.b << 16 | c.g << 8 | c.r;
	return (c);
}

void			print_data_infos(__global t_rt *rt, const t_yx coords, t_ray ray)
{
	int			i = -1;

	(void)ray;
	if (coords.x == 0 && coords.y == 0)
	{
		printf("sizeof(t_vector): %zu\n", sizeof(t_vector));
		printf("sizeof(t_object): %zu\n", sizeof(t_object));
		printf("sizeof(t_light): %zu\n", sizeof(t_light));
		printf("sizeof(t_eye): %zu\n", sizeof(t_eye));
		printf("sizeof(t_color): %zu\n", sizeof(t_color));
		printf("sizeof(t_vector): %zu\n", sizeof(t_vector));
		printf("------ CL -------\n");
		printf("cam---------\n");
		printf("pos: %f %f %f\n", rt->eye.pos.x, rt->eye.pos.y, rt->eye.pos.z);
		printf("rot: %f %f %f\n", rt->eye.rot.x, rt->eye.rot.y, rt->eye.rot.z);
		printf("fov: %f zoom: %f aspect: %f\n", rt->eye.fov, rt->eye.zoom, rt->eye.aspect);
		printf("m[3]--------\n");
		printf("m[i]: %f %f %f\n", rt->m[0].x, rt->m[0].y, rt->m[0].z);
		printf("m[1]: %f %f %f\n", rt->m[1].x, rt->m[1].y, rt->m[1].z);
		printf("m[2]: %f %f %f\n", rt->m[2].x, rt->m[2].y, rt->m[2].z);
	
		printf("objs--------\n\n");
		while (++i < 2)
		{
			printf("id: %d\n", i);
			printf("pos: %f %f %f\n", rt->objects[i].pos.x, rt->objects[i].pos.y, rt->objects[i].pos.z);
			printf("rot: %f %f %f\n", rt->objects[i].rot.x, rt->objects[i].rot.y, rt->objects[i].rot.z);
			printf("size: %f %f %f\n", rt->objects[i].size.x, rt->objects[i].size.y, rt->objects[i].size.z);
			printf("refract: %f reflect: %f spec: %f\n", rt->objects[i].refract, rt->objects[i].reflect, rt->objects[i].spec);
			printf("type: %d\n", rt->objects[i].type);
			printf("perturbation normale: %f\n", rt->objects[i].np);
			printf("texture procedurale: %d\n", rt->objects[i].p_texture);
			printf("color: %d\nrgb: %d %d %d\n\n", rt->objects[i].color.c, rt->objects[i].color.r, rt->objects[i].color.g, rt->objects[i].color.b);
		}
		i = -1;
		printf("lgts--------\n\n");
		while (++i < 2)
		{
			printf("id: %d\n", i);
			printf("pos: %f %f %f\n", rt->lights[i].pos.x, rt->lights[i].pos.y, rt->lights[i].pos.z);
			printf("intensity: %f\n\n", rt->lights[i].intensity);
		}
		printf("autre-------\n\n");
		printf("shadows: %d line: %d\n", rt->shadows, rt->line);
		printf("nbl: %d nbo: %d\n", rt->nb_light, rt->nb_obj);
		printf("effects: %d\n", rt->effects);
		printf("\n");
	}
}

__kernel void	core(__global uint *pixels, __global t_rt *rt, \
								__constant t_key *keys, __constant double *rand)
{
	const t_yx	coords = (t_yx){(int)get_global_id(GLOBAL_Y), \
												(int)get_global_id(GLOBAL_X)};
	const t_yx	size = (t_yx){(int)get_global_size(GLOBAL_Y), \
												(int)get_global_size(GLOBAL_X)};
	t_ray		ray = ft_init_ray(rt, coords, size);;
	t_object	obj;
	int			color;

	// print_data_infos(rt, coords, ray);
	ft_check_collisions(rt, &ray);
	obj = rt->objects[ray.id];
	if (rt->effects && (rt->objects[ray.id].reflect || rt->objects[ray.id].refract || rt->objects[ray.id].transp) && ray.id != -1)
		color = ft_reflection(rt, &ray, rand).c;
	else if (ray.id != -1)
		color = ft_color(rt, ray, ft_light(rt, &ray, rand), rand).c;
	else
		color = 0xff000000;
	put_pixel(pixels, coords, size, color, ray);
}
