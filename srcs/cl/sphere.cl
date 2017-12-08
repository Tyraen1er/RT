/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   sphere.cl                                          :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: bmoiroud <bmoiroud@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2017/10/31 17:12:34 by bmoiroud          #+#    #+#             */
/*   Updated: 2017/11/05 17:20:50 by bmoiroud         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "rt.h.cl"

static void		ft_sphere_col(const t_object obj, t_ray *ray, __global t_rt *rt)
{
	const t_vector		dist = ray->pos - obj.pos;
	t_equation	e = {
		.a = dot(ray->dir, ray->dir), \
		.b = 2 * dot(ray->dir, dist), \
		.c = dot(dist, dist) - (obj.size.x * obj.size.x), \
		.delta = e.b * e.b - 4.0 * e.a * e.c
	};

	if (e.delta < 0.0)
		return ;
	e.c = (-e.b + sqrt(e.delta)) / (2.0 * e.a);
	e.delta = (-e.b - sqrt(e.delta)) / (2.0 * e.a);
	if (e.c > e.delta)
		e.c = e.delta;
	if (e.c > 0.0000001 && e.c < ray->t)
		ray->t = e.c;
}
