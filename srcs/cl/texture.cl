/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   texture.cl                                         :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: bmoiroud <bmoiroud@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2017/11/04 15:46:09 by bmoiroud          #+#    #+#             */
/*   Updated: 2017/11/05 17:27:59 by bmoiroud         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "rt.h.cl"

static t_color		ft_chessboard(const t_vector hit, const __global t_object *obj, const t_vector n)
{
	const t_vector	v = hit - obj->pos;
	t_vector	pos;

	// if (obj->type == SPHERE)
		// printf("1\n");
	pos.x = fabs(fmod(v.x, 20.0));
	pos.y = fabs(fmod(v.y, 20.0));
	pos.z = fabs(fmod(v.z, 20.0));
	if (pos.x < 10.0 && pos.y < 10.0 && pos .z < 10.0)
		return ((t_color){0, 0, 0, 0});
	if (pos.x > 10.0 && pos.y < 10.0 && pos .z > 10.0)
		return ((t_color){0, 0, 0, 0});
	if (pos.x < 10.0 && pos.y > 10.0 && pos .z > 10.0)
		return ((t_color){0, 0, 0, 0});
	if (pos.x > 10.0 && pos.y > 10.0 && pos .z < 10.0)
		return ((t_color){0, 0, 0, 0});
	return ((t_color){0xff, 0xff, 0xff, 0xffffffff});
}

static t_color		ft_procedural_texture(__global t_rt *rt, const t_ray ray, \
								__global t_object *obj, __constant double *rand)
{
//	const t_vector	hit = ray.pos + ray.dist * ray.dir;

	// if (obj->p_texture == 0)
	// 	return (ft_chessboard(hit, obj, ft_normale(rt, obj, hit, &ray, rand)));
	// else if (obj->p_texture == WOOD)
	// else if (obj->p_texture == MARBLE)
	// else if (obj->p_texture == BRICKS)
	// else if (obj->p_texture == PERLIN)
	return ((t_color){0, 0, 0, 0});
}
