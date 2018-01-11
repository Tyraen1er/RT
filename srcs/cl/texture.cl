/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   texture.cl                                         :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: bmoiroud <bmoiroud@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2017/11/04 15:46:09 by bmoiroud          #+#    #+#             */
/*   Updated: 2017/12/08 17:47:18 by bmoiroud         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "rt.h.cl"
#include "chessboard.cl"
#include "bricks.cl"
#include "wood.cl"
#include "marble.cl"
#include "noise.cl"

static double2		ft_get_text_coords(const t_vector hit, __global \
			t_object *obj, const t_ray *ray, __constant double *rand, __global t_rt *rt)
{
	if (obj->type == SPHERE)
		return (ft_sphere_text_coords(hit, obj));
	else if (obj->type == PLANE)
		return (ft_plane_text_coords(hit, obj));
	else if (obj->type == CONE)
		return (ft_cyl_text_coords(hit, obj, ray));
	else
		return (ft_cyl_text_coords(hit, obj, ray));
}

static t_color		ft_procedural_texture(__global t_rt *rt, t_ray ray, \
								__global t_object *obj, __constant double *rand)
{
	const t_vector	hit = ray.pos + ((ray.dist - .1) * ray.dir);

	if (obj->p_texture == CHESSBOARD)
		return (ft_chessboard(ft_get_text_coords(hit, obj, &ray, rand, rt), obj, ft_normale(rt, obj, hit, &ray, rand)));
	else if (obj->p_texture == WOOD)
		return (ft_wood(hit, obj, ft_normale(rt, obj, hit, &ray, rand), rand));
	else if (obj->p_texture == MARBLE)
		return (ft_marble(hit, obj, ft_normale(rt, obj, hit, &ray, rand), rand));
	else if (obj->p_texture == BRICKS)
		return (ft_bricks(ft_get_text_coords(hit, obj, &ray, rand, rt), &rand[(int)fmod(fabs(((hit.x * 10000000.0) + (hit.y * 10000000.0) + (hit.z * 10000000.0))), MAX_RAND) - 1], obj));
	else if (obj->p_texture == PERLIN)
	{
		double	p = ft_perlin_noise(obj, hit, rand);
		t_color	c = {
			.b = min(max((int)(p * 255), 0), 255), \
			.g = min(max((int)(p * 255), 0), 255), \
			.r = min(max((int)(p * 255), 0), 255), \
			.c = 0xff << 24 | c.b << 16 | c.g << 8 | c.r
		};
		return (c);
	}
		// return (ft_perlin_noise(rt, obj, hit, ft_normale(rt, obj, hit, &ray, rand), rand));
	return ((t_color){0, 0, 0, 0});
}