/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   cone.cl                                            :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: bmoiroud <bmoiroud@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2017/10/31 17:12:25 by bmoiroud          #+#    #+#             */
/*   Updated: 2017/11/03 14:01:39 by bmoiroud         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "rt.h.cl"

static void		ft_cone_col(const t_object obj, t_ray *ray, __global t_rt *rt)
{
	const t_vector		dist = ray->pos - obj.pos;
	const t_vector		rot = obj.rot;
	t_equation	e = {
		.a = dot(ray->dir, ray->dir) - (1.0 + pow(tan(PI * (obj.size.x / 180.0)), 2.0)) * pow(dot(ray->dir, rot), 2.0), \
		.b = 2 * (dot(ray->dir, dist) - (1.0 + pow(tan(PI * (obj.size.x / 180.0)), 2.0)) * dot(ray->dir, rot) * dot(dist, rot)), \
		.c = dot(dist, dist) - (1.0 + pow(tan(PI * (obj.size.x / 180.0)), 2.0)) * pow(dot(dist, rot), 2.0), \
		.delta = e.b * e.b - 4.0 * e.a * e.c
	};

	if (e.delta < 0.0)
		return ;
	e.c = (-e.b + sqrt(e.delta)) / (2.0 * e.a);
	e.delta = (-e.b - sqrt(e.delta)) / (2.0 * e.a);
	//if (obj.size.y != -1)
	//	ft_limited_cone(obj, ray, e);
	if (e.c > e.delta)
		e.c = e.delta;
	if (e.c > 0.0000001 && e.c < ray->t)
		ray->t = e.c;
}
