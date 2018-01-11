/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   marble.cl                                          :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: bmoiroud <bmoiroud@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2017/12/04 18:28:46 by bmoiroud          #+#    #+#             */
/*   Updated: 2017/12/05 14:15:35 by bmoiroud         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "rt.h.cl"

static t_color		ft_marble(const t_vector hit, const __global t_object *obj, const t_vector n, __constant double *rand)
{
	return ((t_color){0, 0, 0, 0});
}