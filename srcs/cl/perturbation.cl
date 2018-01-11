/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   perturbation.cl                                    :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: bmoiroud <bmoiroud@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2017/11/11 17:32:33 by bmoiroud          #+#    #+#             */
/*   Updated: 2017/12/05 14:58:02 by bmoiroud         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "rt.h.cl"

static t_vector		ft_bricks_pert(const double2 coords, __constant double *rand)
{
	const int		r = (int)(*rand * 15168.5236) % 100;
	const double	v = floor(coords.y / (BRICK_H + (2.0 * MORTAR_H)));
	const double	u = (fabs(fmod(v, 2.0)) > 0.0001) ? coords.x + (BRICK_W / 2.0) + MORTAR_W : coords.x;
	const double	v2 = fmod(coords.y, (BRICK_H + 2.0 * MORTAR_H));
	const double	u2 = fmod(u, (BRICK_W + 2.0 * MORTAR_W));

	return ((t_vector){0, 0, 0});
}

static t_vector		ft_chess_pert(const double2 coords, __constant double *rand, const t_ray *ray)
{
	const t_vector	hit = ray->dir * ray->dist + ray->pos;
	const double2	c = {
		floor(hit.x * coords.x), \
		floor(hit.y * coords.y)
	};
	const double	x = fmod(c.x, 2.0);
	const double	y = fmod(c.y, 2.0);

	// if ((x >= 0.0 && x <= 0.2) && (y > 0.2 && y < 1.8))
	return ((t_vector){0, 0, 0});
}

static t_vector		ft_proc_perturb(__global t_rt *rt, t_vector n, __global \
					t_object *obj, __constant double *rand, const t_vector hit, const t_ray *ray)
{
	if (obj->p_texture == BRICKS)
		return (ft_bricks_pert(ft_get_text_coords(hit, obj, ray, rand, rt), rand));
	else if (obj->p_texture == CHESSBOARD)
		return (ft_chess_pert(ft_get_text_coords(hit, obj, ray, rand, rt), rand, ray));
	return ((t_vector){0, 0, 0});
}