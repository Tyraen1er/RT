/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   normale.cl                                         :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: bmoiroud <bmoiroud@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2017/09/25 13:50:13 by bmoiroud          #+#    #+#             */
/*   Updated: 2017/12/04 14:34:04 by bmoiroud         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "rt.h.cl"
#include "perturbation.cl"

static t_vector		ft_check_norm(t_vector n, __global t_rt *rt, __global t_object *o)
{
	if ((rt->eye.pos.y > o->pos.y && o->rot.y < 0) || \
									(rt->eye.pos.y < o->pos.y && o->rot.y > 0))
		n.y *= -1;
	if ((rt->eye.pos.x < o->pos.x && o->rot.x > 0) || \
									(rt->eye.pos.x > o->pos.x && o->rot.x < 0))
		n.x *= -1;
	if ((rt->eye.pos.z > o->pos.z && o->rot.z < 0) || \
									(rt->eye.pos.z < o->pos.z && o->rot.z > 0))
		n.z *= -1;
	return (n);
}

static t_vector		ft_perturbation(__global t_rt *rt, t_vector n, __global \
						t_object *obj, __constant double *rand, const t_vector hit, const t_ray *ray)
{
	// printf("perturbation 1\n");
	if (obj->np > 0 && rt->effects == 1)
	{
		n.x += sin(n.x * obj->np) * n.x / 10.0;
		n.y += sin(n.y * obj->np) * n.y / 10.0;
		n.z += sin(n.z * obj->np) * n.z / 10.0;
	}
	if (obj->p_texture != -1)
		return (ft_proc_perturb(rt, n, obj, rand, hit, ray));
	return(n);
}

static t_vector		ft_normale(__global t_rt *rt, __global t_object *obj, \
								const t_vector hit, const t_ray *ray, __constant double *rand)
{
	t_vector	v1;

	if (obj->type == PLANE)
		v1 = ft_check_norm(obj->rot, rt, obj);
	else if (obj->type == SPHERE)
		v1 = hit - obj->pos;
	else
	{
		if (ray->id != 0 && ray->bounces == -2)
			// printf("normale1 : %d\n", ray->id);
		v1 = obj->rot * (dot(ray->dir, obj->rot) * ray->dist + \
											dot(ray->pos - obj->pos, obj->rot));
		if (obj->type == CONE)
			v1 = v1 * (1.0 + pow(tan(obj->size.x / 180.0 / PI) , 2.0));
		v1 = (hit - obj->pos) - v1;
	}
	return (normalize(v1 + ft_perturbation(rt, v1, obj, rand, ray->pos + ((ray->dist - .1) * ray->dir), ray)));
}