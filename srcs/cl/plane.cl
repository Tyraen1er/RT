/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   plane.cl                                           :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: bmoiroud <bmoiroud@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2017/10/31 17:12:20 by bmoiroud          #+#    #+#             */
/*   Updated: 2017/10/31 17:15:07 by bmoiroud         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "rt.h.cl"

static void		ft_plane_col(const t_object obj, t_ray *ray, __global t_rt *rt)
{
	const double	d = (dot(obj.rot, obj.pos) - dot(obj.rot, ray->pos)) \
												/ dot(obj.rot, ray->dir);
	if (d > 0.0000001 && d < ray->t)
		ray->t = d;
}
